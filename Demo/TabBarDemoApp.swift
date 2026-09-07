import SwiftUI
import MinimizingTabBar

@main
struct TabBarDemoApp: App {
    var body: some Scene {
        WindowGroup { DemoView().preferredColorScheme(.dark) }
    }
}

private enum DemoTab: String { case people, places }

private struct Person: Identifiable {
    let id: Int
    let name: String
    let context: String
    let initials: String
    let color: Color
}

private let people: [Person] = [
    .init(id: 0, name: "Sofia Chen", context: "Design evening · Brooklyn", initials: "SC", color: Color(red: 0.51, green: 0.61, blue: 0.47)),
    .init(id: 1, name: "Oliver James", context: "Sunday coffee · West Village", initials: "OJ", color: Color(red: 0.70, green: 0.47, blue: 0.31)),
    .init(id: 2, name: "Maya Patel", context: "Gallery opening · Chelsea", initials: "MP", color: Color(red: 0.55, green: 0.44, blue: 0.63)),
    .init(id: 3, name: "Noah Williams", context: "Running club · Central Park", initials: "NW", color: Color(red: 0.38, green: 0.52, blue: 0.67)),
    .init(id: 4, name: "Isabella Rossi", context: "Dinner with friends · SoHo", initials: "IR", color: Color(red: 0.66, green: 0.42, blue: 0.48)),
    .init(id: 5, name: "Leo Park", context: "Bookshop talk · Greenpoint", initials: "LP", color: Color(red: 0.43, green: 0.61, blue: 0.57)),
    .init(id: 6, name: "Amara Okafor", context: "Photography walk · DUMBO", initials: "AO", color: Color(red: 0.68, green: 0.57, blue: 0.36)),
    .init(id: 7, name: "Theo Martin", context: "Jazz night · East Village", initials: "TM", color: Color(red: 0.45, green: 0.48, blue: 0.64)),
    .init(id: 8, name: "Yuki Tanaka", context: "Ceramics studio · Williamsburg", initials: "YT", color: Color(red: 0.61, green: 0.47, blue: 0.43)),
    .init(id: 9, name: "Eli Brooks", context: "Weekend market · Fort Greene", initials: "EB", color: Color(red: 0.44, green: 0.56, blue: 0.44)),
    .init(id: 10, name: "Ava Laurent", context: "Film screening · Tribeca", initials: "AL", color: Color(red: 0.61, green: 0.45, blue: 0.57)),
    .init(id: 11, name: "Finn Clarke", context: "Morning run · Prospect Park", initials: "FC", color: Color(red: 0.44, green: 0.56, blue: 0.62)),
    .init(id: 12, name: "Luna Reyes", context: "Listening party · Bushwick", initials: "LR", color: Color(red: 0.67, green: 0.49, blue: 0.32)),
    .init(id: 13, name: "Kai Anderson", context: "Studio visit · Red Hook", initials: "KA", color: Color(red: 0.47, green: 0.57, blue: 0.52))
]

struct DemoView: View {
    @State private var bar = TabBarState()
    @State private var selection: DemoTab = .people
    @State private var selectedPerson: Person?
    @State private var showSearch = false
    @State private var query = ""
    @State private var scrollToTop = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            Color(red: 0.045, green: 0.049, blue: 0.043).ignoresSafeArea()
            if let person = selectedPerson {
                detail(person)
            } else if selection == .people {
                peopleScreen
            } else {
                placesScreen
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            MinimizingTabBar(
                items: [
                    TabBarItem(.people, title: "People", systemImage: "person.2"),
                    TabBarItem(.places, title: "Places", systemImage: "map")
                ],
                selection: $selection, state: bar,
                leading: selectedPerson == nil ? nil : .init("Back", systemImage: "chevron.left") {
                    withAnimation(.snappy) { selectedPerson = nil }
                },
                trailing: .init("Search", systemImage: "magnifyingglass") { showSearch = true },
                onReselect: { _ in
                    selectedPerson = nil
                    scrollToTop += 1
                }
            )
            .padding(.horizontal, 22)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .background {
                LinearGradient(
                    colors: [Color(red: 0.045, green: 0.049, blue: 0.043).opacity(0.75), Color(red: 0.045, green: 0.049, blue: 0.043)],
                    startPoint: .top, endPoint: .bottom
                )
                .padding(.top, -10)
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .overlay(alignment: .top) {
            GeometryReader { geometry in
                Color(red: 0.045, green: 0.049, blue: 0.043)
                    .frame(height: geometry.safeAreaInsets.top)
                    .offset(y: -geometry.safeAreaInsets.top)
            }
            .allowsHitTesting(false)
        }
        .onChange(of: selection) { _, _ in selectedPerson = nil }
        .sheet(isPresented: $showSearch) { searchScreen }
        .tint(.white)
    }

    private var peopleScreen: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    header(eyebrow: "YOUR LITTLE WORLD", title: "Good company.", subtitle: "The people you’re glad you met.")
                        .id("top")
                    sectionLabel("RECENTLY MET", trailing: "14 people")
                        .padding(.top, 35).padding(.bottom, 12)
                    ForEach(people) { person in
                        Button {
                            bar.restore(animated: !reduceMotion)
                            withAnimation(.snappy) { selectedPerson = person }
                        } label: { row(person) }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("person-\(person.id)")
                    }
                    Text("Small moments. Lasting connections.")
                        .font(.system(size: 13)).foregroundStyle(.white.opacity(0.35))
                        .frame(maxWidth: .infinity).padding(.vertical, 28)
                }
                .padding(.horizontal, 26)
            }
            .accessibilityIdentifier("people-scroll")
            .scrollIndicators(.hidden)
            .minimizesTabBarOnScroll(bar)
            .onChange(of: scrollToTop) { _, _ in
                withAnimation(.smooth) { proxy.scrollTo("top", anchor: .top) }
            }
        }
    }

    private var placesScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header(eyebrow: "PLACES THAT CONNECT US", title: "Around here.", subtitle: "Every connection starts somewhere.")
                ForEach(Array([("Brooklyn", "7 connections", "building.2", Color(red: 0.39, green: 0.48, blue: 0.34)),
                               ("Manhattan", "7 connections", "building.2.crop.circle", Color(red: 0.42, green: 0.38, blue: 0.31))].enumerated()), id: \.offset) { _, place in
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(LinearGradient(colors: [place.3, place.3.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        Image(systemName: place.2).font(.system(size: 100, weight: .ultraLight))
                            .foregroundStyle(.white.opacity(0.16)).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing).padding(25)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(place.0).font(.system(size: 27, weight: .medium, design: .serif))
                            Text(place.1).font(.system(size: 13)).foregroundStyle(.white.opacity(0.6))
                        }.padding(24)
                    }.frame(height: 190)
                }
            }.padding(.horizontal, 26)
        }
        .scrollIndicators(.hidden)
        .minimizesTabBarOnScroll(bar)
    }

    private func detail(_ person: Person) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("A GOOD CONNECTION").font(.system(size: 10, weight: .semibold)).tracking(2).foregroundStyle(.white.opacity(0.4))
            avatar(person, size: 92).padding(.top, 24)
            Text(person.name).font(.system(size: 42, weight: .regular, design: .serif))
            Text(person.context).font(.system(size: 15)).foregroundStyle(.white.opacity(0.5))
            Rectangle().fill(.white.opacity(0.1)).frame(height: 1).padding(.vertical, 12)
            Text("A moment worth remembering.").font(.system(size: 23, design: .serif))
            Text("Keep the little details that make the next hello feel familiar.")
                .font(.system(size: 17)).foregroundStyle(.white.opacity(0.5)).lineSpacing(5)
            Spacer()
        }.padding(.horizontal, 30).padding(.top, 24).frame(maxWidth: .infinity, alignment: .leading)
    }

    private var searchScreen: some View {
        NavigationStack {
            List(people.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }) { person in
                row(person)
            }
            .navigationTitle("Find someone")
            .searchable(text: $query, prompt: "Search people")
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { showSearch = false } } }
        }.preferredColorScheme(.dark)
    }

    private func header(eyebrow: String, title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "asterisk").font(.system(size: 20, weight: .medium)).foregroundStyle(Color(red: 0.76, green: 0.86, blue: 0.58))
                Spacer()
                Text("FIELDNOTES").font(.system(size: 10, weight: .semibold)).tracking(2.5).foregroundStyle(.white.opacity(0.4))
            }.padding(.bottom, 35)
            Text(eyebrow).font(.system(size: 9, weight: .semibold)).tracking(2).foregroundStyle(.white.opacity(0.4))
            Text(title).font(.system(size: 43, weight: .regular, design: .serif)).tracking(-1.5)
            Text(subtitle).font(.system(size: 14)).foregroundStyle(.white.opacity(0.45))
        }.padding(.top, 15)
    }

    private func sectionLabel(_ title: String, trailing: String) -> some View {
        HStack {
            Text(title).font(.system(size: 9, weight: .semibold)).tracking(1.5)
            Spacer()
            Text(trailing).font(.system(size: 11))
        }.foregroundStyle(.white.opacity(0.35))
    }

    private func row(_ person: Person) -> some View {
        HStack(spacing: 14) {
            avatar(person, size: 47)
            VStack(alignment: .leading, spacing: 5) {
                Text(person.name).font(.system(size: 17, weight: .medium)).foregroundStyle(.white.opacity(0.92))
                Text(person.context).font(.system(size: 11)).foregroundStyle(.white.opacity(0.4))
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.system(size: 10, weight: .medium)).foregroundStyle(.white.opacity(0.25))
        }.padding(.vertical, 15)
            .overlay(alignment: .bottom) { Rectangle().fill(.white.opacity(0.055)).frame(height: 0.5) }
            .contentShape(.rect)
    }

    private func avatar(_ person: Person, size: CGFloat) -> some View {
        ZStack {
            Circle().fill(LinearGradient(colors: [person.color, person.color.opacity(0.45)], startPoint: .topLeading, endPoint: .bottomTrailing))
            Text(person.initials).font(.system(size: size * 0.28, weight: .medium, design: .serif)).foregroundStyle(.white.opacity(0.85))
        }.frame(width: size, height: size)
    }
}

#Preview { DemoView().preferredColorScheme(.dark) }

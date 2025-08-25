import SwiftUI
import WebKit
import CoreLocation   // ← nový import (kvůli LocationWebView)

// MARK: - Jednoduchý univerzální web-view (bez polohy)
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}


// MARK: - Web-view, který si při prvním zobrazení vyžádá polohu
struct LocationWebView: UIViewRepresentable {
    let url: URL
    private let locationManager = CLLocationManager()

    func makeUIView(context: Context) -> WKWebView {
        // iOS 14+: instanční authorizationStatus (bez deprecated warningu)
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}


// MARK: - Hlavní stránka – textová stránka s odkazy, textem MHD, obrázkem
struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    Image("mhd")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .edgesIgnoringSafeArea(.top)

                    VStack(spacing: 15) {

                        Text("Jízdní řády MHD Jihlava")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.top)

                        NavigationLink { LineB_View() } label: {
                            Text("Jízdní řád linky B")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(width: 250)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }

                        NavigationLink { LineC_View() } label: {
                            Text("Jízdní řád linky C")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(width: 250)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }

                        NavigationLink { LineG_View() } label: {
                            Text("Jízdní řád linky G")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(width: 250)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }

                        NavigationLink { Line12_View() } label: {
                            Text("Jízdní řád linky 12")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(width: 250)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }

                        Text("Mapa spojů")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.top)

                        NavigationLink { MapaSpoju_View() } label: {
                            Text("Mapa spojů")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(width: 250)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }

                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
    }
}


// MARK: - Mapa spojů – Webová stránka DPMJ (používá LocationWebView)
struct MapaSpoju_View: View {
    var body: some View {
        LocationWebView(url: URL(string: "https://sgis.jihlava-city.cz/web/mhd/")!)
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("Mapa spojů")
            .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Linka B – stránka s odkazy
struct LineB_View: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Jízdní řád linky B")
                    .font(.title)
                    .padding(.bottom, 20)

                Divider()

                Text("Směr: Náměstí")
                    .font(.title)
                    .padding(.bottom, 20)

                NavigationLink { NaHeleninske1_View() } label: {
                    Text("Zastávka: Na Helenínské")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                Divider()

                Text("Směr: Na Helenínské")
                    .font(.title)
                    .padding(.bottom, 20)

                NavigationLink { Namesti_View() } label: {
                    Text("Zastávka: Náměstí dolní")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Linka B")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


// MARK: - Na Helenínské – směr Náměstí (linka B)
struct NaHeleninske1_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/B/domov.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Na Helenínské")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Náměstí dolní – směr Na Helenínské (linka B)
struct Namesti_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/B/namesti.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Masarykovo náměstí dolní")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Linka C – stránka s odkazy
struct LineC_View: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Jízdní řád linky C")
                    .font(.title)
                    .padding(.bottom, 20)

                Text("AKTUÁLNĚ (9. 5. 25): Linka C nyní v dobách oprav končí na zastávce Chlumova a zastávku Kaufland neobsluhuje")

                Divider()

                Text("Směr: Náměstí")
                    .font(.title)
                    .padding(.bottom, 20)

                NavigationLink { NaHeleninske_View() } label: {
                    Text("Zastávka: Na Helenínské")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                Divider()

                Text("Směr: Na Helenínské")
                    .font(.title)
                    .padding(.bottom, 20)

                NavigationLink { Namesti2_View() } label: {
                    Text("Zastávka: Náměstí dolní")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                Divider()

                Text("Směr: Chlumova")
                    .font(.title)
                    .padding(.bottom, 20)

                NavigationLink { NaHeleninske2_View() } label: {
                    Text("Zastávka: Na Helenínské")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Linka C")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


// MARK: - Na Helenínské – směr Náměstí (linka C)
struct NaHeleninske_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/C/domov.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Na Helenínské")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Náměstí dolní – směr Na Helenínské (linka C)
struct Namesti2_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/C/namesti.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Masarykovo náměstí dolní")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Na Helenínské – směr Chlumova / Kaufland (linka C)
struct NaHeleninske2_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/C/heleniska-kauf.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Na Helenínské")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Linka G – stránka s odkazy
struct LineG_View: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Jízdní řád linky G")
                    .font(.title)
                    .padding(.bottom, 20)

                Divider()

                Text("Směr: Antonínův Důl")
                    .font(.title)
                    .padding(.bottom, 20)

                NavigationLink { NamestiG_View() } label: {
                    Text("Zastávka: Náměstí dolní")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                NavigationLink { ChlumovaG_View() } label: {
                    Text("Zastávka: Chlumova")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                NavigationLink { KauflandG_View() } label: {
                    Text("Zastávka: Kaufland")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                NavigationLink { PrekladisteG_View() } label: {
                    Text("Zastávka: Překladiště Pávov")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                Divider()

                Text("Směr: Náměstí dolní")
                    .font(.title)
                    .padding(.bottom, 20)

                NavigationLink { ADulG_View() } label: {
                    Text("Zastávka: Antonínův Důl")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                NavigationLink { CKrizG_View() } label: {
                    Text("Zastávka: Červený kříž")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Linka G")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


// MARK: - Náměstí G
struct NamestiG_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/G/namesti-G.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Masarykovo náměstí dolní")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Chlumova G
struct ChlumovaG_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/G/chlumova-G.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Chlumova")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Kaufland G
struct KauflandG_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/G/kaufland-G.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Kaufland")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Překladiště G
struct PrekladisteG_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/G/prekladiste-G.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Překladiště Pávov")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Antonínův Důl G
struct ADulG_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/G/ADul-G.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Antonínův Důl")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Červený Kříž G
struct CKrizG_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/G/CKriz-G.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Červený Kříž")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Linka 12 – stránka s odkazy
struct Line12_View: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Jízdní řád linky 12")
                    .font(.title)
                    .padding(.bottom, 20)

                Divider()

                Text("Směr: Antonínův Důl")
                    .font(.title)
                    .padding(.bottom, 20)

                NavigationLink { Namesti12_View() } label: {
                    Text("Zastávka: Náměstí dolní")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                NavigationLink { Chlumova12_View() } label: {
                    Text("Zastávka: Chlumova")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                NavigationLink { Kaufland12_View() } label: {
                    Text("Zastávka: Kaufland")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                NavigationLink { Prekladiste12_View() } label: {
                    Text("Zastávka: Překladiště Pávov")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                Divider()

                Text("Směr: Náměstí dolní")
                    .font(.title)
                    .padding(.bottom, 20)

                NavigationLink { ADul12_View() } label: {
                    Text("Zastávka: Antonínův Důl")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                NavigationLink { CKriz12_View() } label: {
                    Text("Zastávka: Červený kříž")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Linka 12")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


// MARK: - Náměstí 12
struct Namesti12_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/12/namesti-12.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Masarykovo náměstí dolní")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Chlumova 12
struct Chlumova12_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/12/chlumova-12.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Chlumova")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Kaufland 12
struct Kaufland12_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/12/kaufland-12.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Kaufland")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Překladiště 12
struct Prekladiste12_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/12/prekladiste-12.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Překladiště Pávov")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Antonínův Důl 12
struct ADul12_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/12/ADul-12.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Antonínův Důl")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Červený Kříž 12
struct CKriz12_View: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            AsyncImage(url: URL(string: "https://kubatube.cz/JizdniRady/12/CKriz-12.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture().onChanged { scale = $0 })
            } placeholder: { ProgressView() }
            .padding()
        }
        .navigationTitle("Červený Kříž")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Náhled v preview
#Preview {
    ContentView()
}

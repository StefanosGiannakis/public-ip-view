import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), ipAddress: "Loading...")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), ipAddress: "Loading...")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Get the IP address from shared UserDefaults
        let sharedDefaults = UserDefaults(suiteName: "group.com.example.publicIpView")
        let ipAddress = sharedDefaults?.string(forKey: "ip_address") ?? "No IP available"
        
        // Generate a timeline with one entry that refreshes every 30 minutes
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, ipAddress: ipAddress)
        entries.append(entry)
        
        // Create a timeline that refreshes every 30 minutes
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let ipAddress: String
}

struct PublicIPWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color(red: 0.2, green: 0.2, blue: 0.2)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Public IP Address")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.bottom, 4)
                
                Text(entry.ipAddress)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                Text("Last updated:")
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                Text(entry.date, style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

@main
struct PublicIPWidget: Widget {
    let kind: String = "PublicIPWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PublicIPWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Public IP Widget")
        .description("Displays your current public IP address.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct PublicIPWidget_Previews: PreviewProvider {
    static var previews: some View {
        PublicIPWidgetEntryView(entry: SimpleEntry(date: Date(), ipAddress: "192.168.1.1"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
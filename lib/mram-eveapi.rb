# vim: set foldmethod=marker smarttab sw=2: #

require 'rubygems'
require 'httpclient'
require 'nokogiri'
require './lib/models.rb'
require 'logger'

class EveApi
  @@url_list = 'http://wiki.eve-id.net/APIv2_Page_Index'
  @@base_url = 'https://api.eveonline.com'
  @@urls = { # {{{
            :AccountStatus => {:group=>"Account", :url=>"/account/AccountStatus.xml.aspx", :name=>"Account Status"},
               :APIKeyInfo => {:group=>"Account", :url=>"/account/APIKeyInfo.xml.aspx", :name=>"API Key Info"},
               :Characters => {:group=>"Account", :url=>"/account/Characters.xml.aspx", :name=>"Characters (List of)"},
           :AccountBalance => {:group=>"Corporation", :url=>"/corp/AccountBalance.xml.aspx", :name=>"Account Balances"},
                :AssetList => {:group=>"Corporation", :url=>"/corp/AssetList.xml.aspx", :name=>"Asset List"},
   :CalendarEventAttendees => {:group=>"Character", :url=>"/char/CalendarEventAttendees.xml.aspx", :name=>"Calendar Event Attendees"},
           :CharacterSheet => {:group=>"Character", :url=>"/char/CharacterSheet.xml.aspx", :name=>"Character Sheet"},
              :ContactList => {:group=>"Corporation", :url=>"/corp/ContactList.xml.aspx", :name=>"Contact List"},
     :ContactNotifications => {:group=>"Character", :url=>"/char/ContactNotifications.xml.aspx", :name=>"Contact Notifications"},
                :Contracts => {:group=>"Corporation", :url=>"/corp/Contracts.xml.aspx", :name=>"Contracts"},
            :ContractItems => {:group=>"Corporation", :url=>"/corp/ContractItems.xml.aspx", :name=>"ContractItems"},
             :ContractBids => {:group=>"Corporation", :url=>"/corp/ContractBids.xml.aspx", :name=>"ContractBids"},
              :FacWarStats => {:group=>"Eve", :url=>"/eve/FacWarStats.xml.aspx", :name=>"Factional Warfare Stats"},
             :IndustryJobs => {:group=>"Corporation", :url=>"/corp/IndustryJobs.xml.aspx", :name=>"Industry Jobs"},
                  :Killlog => {:group=>"Corporation", :url=>"/corp/Killlog.xml.aspx", :name=>"Kill Log (Kill Mails)"},
                :Locations => {:group=>"Corporation", :url=>"/corp/Locations.xml.aspx", :name=>"Locations"},
               :MailBodies => {:group=>"Character", :url=>"/char/MailBodies.xml.aspx", :name=>"Mail Bodies"},
             :MailingLists => {:group=>"Character", :url=>"/char/MailingLists.xml.aspx", :name=>"Mailing Lists"},
             :MailMessages => {:group=>"Character", :url=>"/char/MailMessages.xml.aspx", :name=>"Mail Messages (Headers)"},
             :MarketOrders => {:group=>"Corporation", :url=>"/corp/MarketOrders.xml.aspx", :name=>"Market Orders"},
                   :Medals => {:group=>"Corporation", :url=>"/corp/Medals.xml.aspx", :name=>"Medals"},
            :Notifications => {:group=>"Character", :url=>"/char/Notifications.xml.aspx", :name=>"Notifications"},
        :NotificationTexts => {:group=>"Character", :url=>"/char/NotificationTexts.xml.aspx", :name=>"NotificationTexts"},
                 :Research => {:group=>"Character", :url=>"/char/Research.xml.aspx", :name=>"Research"},
          :SkillInTraining => {:group=>"Character", :url=>"/char/SkillInTraining.xml.aspx", :name=>"Skill in Training"},
               :SkillQueue => {:group=>"Character", :url=>"/char/SkillQueue.xml.aspx", :name=>"Skill Queue"},
                :Standings => {:group=>"Corporation", :url=>"/corp/Standings.xml.aspx", :name=>"Standings (NPC)"},
   :UpcomingCalendarEvents => {:group=>"Character", :url=>"/char/UpcomingCalendarEvents.xml.aspx", :name=>"Upcoming Calendar Events"},
            :WalletJournal => {:group=>"Corporation", :url=>"/corp/WalletJournal.xml.aspx", :name=>"Wallet Journal"},
       :WalletTransactions => {:group=>"Corporation", :url=>"/corp/WalletTransactions.xml.aspx", :name=>"Wallet Transactions"},
             :ContainerLog => {:group=>"Corporation", :url=>"/corp/ContainerLog.xml.aspx", :name=>"Container Log"},
         :CorporationSheet => {:group=>"Corporation", :url=>"/corp/CorporationSheet.xml.aspx", :name=>"Corporation Sheet"},
             :MemberMedals => {:group=>"Corporation", :url=>"/corp/MemberMedals.xml.aspx", :name=>"Member Medals"},
           :MemberSecurity => {:group=>"Corporation", :url=>"/corp/MemberSecurity.xml.aspx", :name=>"Member Security"},
        :MemberSecurityLog => {:group=>"Corporation", :url=>"/corp/MemberSecurityLog.xml.aspx", :name=>"Member Security Log"},
           :MemberTracking => {:group=>"Corporation", :url=>"/corp/MemberTracking.xml.aspx", :name=>"Member Tracking"},
              :OutpostList => {:group=>"Corporation", :url=>"/corp/OutpostList.xml.aspx", :name=>"Outpost List"},
     :OutpostServiceDetail => {:group=>"Corporation", :url=>"/corp/OutpostServiceDetail.xml.aspx", :name=>"Outpost Service Detail"},
             :Shareholders => {:group=>"Corporation", :url=>"/corp/Shareholders.xml.aspx", :name=>"Shareholders"},
           :StarbaseDetail => {:group=>"Corporation", :url=>"/corp/StarbaseDetail.xml.aspx", :name=>"StarbaseDetail Details (POS)"},
             :StarbaseList => {:group=>"Corporation", :url=>"/corp/StarbaseList.xml.aspx", :name=>"Starbase List (POS)"},
                   :Titles => {:group=>"Corporation", :url=>"/corp/Titles.xml.aspx", :name=>"Titles"},
             :AllianceList => {:group=>"Eve", :url=>"/eve/AllianceList.xml.aspx", :name=>"Alliance List"},
          :CertificateTree => {:group=>"Eve", :url=>"/eve/CertificateTree.xml.aspx", :name=>"Certificate Tree"},
              :CharacterID => {:group=>"Eve", :url=>"/eve/CharacterID.xml.aspx", :name=>"Character ID (Name to ID Conversion)"},
            :CharacterInfo => {:group=>"Eve", :url=>"/eve/CharacterInfo.xml.aspx", :name=>"Character Info"},
            :CharacterName => {:group=>"Eve", :url=>"/eve/CharacterName.xml.aspx", :name=>"Character Name (ID to Name Conversion)"},
   :ConquerableStationList => {:group=>"Eve", :url=>"/eve/ConquerableStationList.xml.aspx", :name=>"Conquerable Station List (Includes Outposts)"},
                :ErrorList => {:group=>"Eve", :url=>"/eve/ErrorList.xml.aspx", :name=>"Error List"},
           :FacWarTopStats => {:group=>"Eve", :url=>"/eve/FacWarTopStats.xml.aspx", :name=>"Factional Warfare Top 100 Stats"},
                 :RefTypes => {:group=>"Eve", :url=>"/eve/RefTypes.xml.aspx", :name=>"RefTypes List"},
                :SkillTree => {:group=>"Eve", :url=>"/eve/SkillTree.xml.aspx", :name=>"Skill Tree"},
                 :TypeName => {:group=>"Eve", :url=>"/eve/TypeName.xml.aspx", :name=>"Type Name"},
            :FacWarSystems => {:group=>"Map", :url=>"/map/FacWarSystems.xml.aspx", :name=>"Factional Warfare Systems (Occupancy Map)"},
                    :Jumps => {:group=>"Map", :url=>"/map/Jumps.xml.aspx", :name=>"Jumps"},
                    :Kills => {:group=>"Map", :url=>"/map/Kills.xml.aspx", :name=>"Kills"},
              :Sovereignty => {:group=>"Map", :url=>"/map/Sovereignty.xml.aspx", :name=>"Sovereignty"},
        :SovereigntyStatus => {:group=>"Map", :url=>"/map/SovereigntyStatus.xml.aspx", :name=>"Sovereignty Status (API disabled)"},
             :ServerStatus => {:group=>"Server", :url=>"/server/ServerStatus.xml.aspx", :name=>"Server Status"},
                 :calllist => {:group=>"API", :url=>"/api/calllist.xml.aspx", :name=>"Call List (Access Mask reference)"},
  } # }}}

  cattr_accessor :url_list, :base_url, :urls

  def self.parse_url_list # {{{
    clnt = HTTPClient.new
    content = clnt.get_content(@@url_list)
    doc = Nokogiri::HTML(content)

    urls = {}

    doc.xpath('//h3/span[@class="mw-headline"]').each do |tabcaption|
      group = tabcaption.text.strip!
      tabcaption.parent.next_element.xpath('./tr').each do |tr|
        next if tr.children.first.name == 'th'
        cols = tr.children.collect{|x| x.text.strip}
        if cols[1] =~ /^\/[a-zA-Z]+\/([a-zA-Z]+)\.xml\.aspx$/ then
          id = $1.to_sym
          urls[id] = { :group => group, :url => cols[1], :name => cols[0]}
        end
      end
    end

    printf "@@urls = {\n"
    urls.each do |k,v|
      printf "  %24s => %s,\n", ":"+k.to_s, v
    end
    printf "}\n"
  end # }}}

#  def initialize(keyID, vCode)
#    raise(ArgumentError, "keyID must be numeric!") unless keyID.is_a?(Numeric)
#    @creds = { :keyID => keyID, :vCode => vCode }
#  end

  def get_api_call_list
    doc = call_cached_api(:calllist)
    puts doc.inspect
  end

  def get_api_key_info
    doc = call_cached_api(:APIKeyInfo, @creds)
    puts doc.inspect
  end
end

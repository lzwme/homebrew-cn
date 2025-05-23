cask "autogram" do
  version "2.3.4"
  sha256 "dc35e8fa78df6a2768e3406c8d6f75e1076def6f0f0e2e85408ddc04ee3f7afe"

  url "https:github.comslovensko-digitalautogramreleasesdownloadv#{version}Autogram-#{version}-MacOs.pkg",
      verified: "github.comslovensko-digitalautogram"
  name "autogram"
  desc "Application for electronic signing of signatures"
  homepage "https:sluzby.slovensko.digitalautogram"

  livecheck do
    url :url
    strategy :github_latest
  end

  pkg "Autogram-#{version}-MacOs.pkg"

  # Following 'preflight' is needed to avoid interactive parts of the instalation process. More details in https:github.comHomebrewhomebrew-caskpull201161#discussion_r1950819869
  preflight do
    FileUtils.mkdir_p "#{Dir.home}LibraryApplication SupportAutogramtls"
    FileUtils.touch "#{Dir.home}LibraryApplication SupportAutogramtlsskip"
  end

  uninstall quit:    "digital.slovensko.autogram",
            pkgutil: "digital.slovensko.autogram"

  zap trash: [
    "~LibraryApplication SupportAutogram",
    "~LibraryPreferencesdigital.slovensko.autogram.plist",
    "~LibrarySaved Application Statedigital.slovensko.autogram.savedState",
  ]

  caveats do
    license "https:github.comslovensko-digitalautogramblobmainLICENSE"
  end
end
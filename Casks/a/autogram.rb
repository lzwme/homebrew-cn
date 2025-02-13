cask "autogram" do
  version "2.3.1"
  sha256 "c2e444180ef3e38bfab79e97c3f578c867d09189de0ef867a42b0e9d25ade3c0"

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
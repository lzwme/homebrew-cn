cask "powershell@preview" do
  arch arm: "arm64", intel: "x64"

  version "7.6.0-preview.3"
  sha256 arm:   "61f65861816dd88d8542bd124e9d55ad4cf98403512f7d5c3144fb6f25eb1768",
         intel: "cb8c693aebd3ce0b52bdd5ce10fd92df56cd49db5539f9870067e5e1bb1ed882"

  url "https:github.comPowerShellPowerShellreleasesdownloadv#{version}powershell-#{version}-osx-#{arch}.pkg"
  name "PowerShell"
  desc "Command-line shell and scripting language"
  homepage "https:github.comPowerShellPowerShell"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Unstable versions are correctly marked as "pre-release" on GitHub, so
  # we have to use the `GithubReleases` strategy to identify unstable releases.
  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+[_-](?:preview|rc)(?:\.\d+)?)$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  depends_on macos: ">= :mojave"

  pkg "powershell-#{version}-osx-#{arch}.pkg"

  uninstall pkgutil: "com.microsoft.powershell-preview"

  zap trash: [
        "~.cachepowershell",
        "~.configPowerShell",
        "~.localsharepowershell",
      ],
      rmdir: [
        "~.cache",
        "~.config",
        "~.local",
        "~.localshare",
      ]

  caveats <<~EOS
    To use Homebrew in PowerShell, set:
      Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '$(#{HOMEBREW_PREFIX}binbrew shellenv) | Invoke-Expression'
  EOS
end
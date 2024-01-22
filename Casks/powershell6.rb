cask "powershell6" do
  version "6.2.7"
  sha256 "d968da998b00178f666f342c9823c7df5038947a46d153892b1b20580be8d6d4"

  url "https:github.comPowerShellPowerShellreleasesdownloadv#{version}powershell-#{version}-osx-x64.pkg"
  name "PowerShell"
  desc "Command-line shell and scripting language"
  homepage "https:github.comPowerShellPowerShell"

  deprecate! date: "2023-12-17", because: :discontinued

  conflicts_with cask: "powershell"
  depends_on macos: ">= :high_sierra"

  pkg "powershell-#{version}-osx-x64.pkg"

  uninstall pkgutil: "com.microsoft.powershell"

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
end
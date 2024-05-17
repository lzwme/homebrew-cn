cask "ghdl" do
  arch arm: "llvm", intel: "mcode"

  version "4.1.0"
  sha256 arm:   "f46cfeee85c4d76720f5c0d6ad283754bc1dae57ce9f1a3942086bc270094ddc",
         intel: "8521aafad389eb769de25db13ecaaaade8444431447eb5e801dc2fcf981cdeed"

  url "https:github.comghdlghdlreleasesdownloadv#{version}ghdl-macos-11-#{arch}.tgz"
  name "ghdl"
  desc "VHDL 20089387 simulator"
  homepage "https:github.comghdlghdl"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "binghdl"
  binary "binghwdump"

  postflight do
    puts "Creating library symlinks in #{HOMEBREW_PREFIX}include and #{HOMEBREW_PREFIX}lib"
    File.symlink("#{staged_path}includeghdl", "#{HOMEBREW_PREFIX}includeghdl")
    File.symlink("#{staged_path}libghdl", "#{HOMEBREW_PREFIX}libghdl")
  end

  uninstall_postflight do
    puts "Removing library symlinks in #{HOMEBREW_PREFIX}include and #{HOMEBREW_PREFIX}lib"
    File.unlink("#{HOMEBREW_PREFIX}includeghdl", "#{HOMEBREW_PREFIX}libghdl")
  end

  # No zap stanza required
end
cask "oclint" do
  version "22.02"
  sha256 "6f102a568af3a4344f9658b5f4bdf3d599a851456287bf7a1fae447891f7368c"

  url "https:github.comoclintoclintreleasesdownloadv#{version}oclint-#{version}-llvm-13.0.1-x86_64-darwin-macos-12.2-xcode-13.2.tar.gz",
      verified: "github.comoclintoclint"
  name "OCLint"
  desc "Static source code analysis tool"
  homepage "https:oclint.org"

  binary "oclint-#{version}binoclint-json-compilation-database"
  binary "oclint-#{version}binoclint-xcodebuild"
  binary "oclint-#{version}binoclint"
  binary "oclint-#{version}includec++v1", target: "#{HOMEBREW_PREFIX}includec++v1"
  binary "oclint-#{version}libclang", target: "#{HOMEBREW_PREFIX}libclang"
  binary "oclint-#{version}liboclint", target: "#{HOMEBREW_PREFIX}liboclint"

  caveats do
    requires_rosetta
  end
end
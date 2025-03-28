class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https:www.slideshare.netmono0926licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https:github.commono0926LicensePlistarchiverefstags3.27.0.tar.gz"
  sha256 "48a7939fce29dcb17d8da070ab2f7081355c36aa81f620a1889d21d59ce64ef4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "325e55afd65ba7b9d14fbca5b73d50c71247c2c38529b8ac538ce6c68f546946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c40c5664f40e2d3cf8ff8f03e1dacea7bcb847c60b75a9aca041cdff974a6faa"
    sha256 cellar: :any,                 arm64_ventura: "a7b0a3380aa24d1efcf1ce314861decff4c162b05936256033d75c3ff06ac867"
    sha256 cellar: :any_skip_relocation, sonoma:        "063ee0f011d3639306cbc09c363bd636a5a73a5607c72065ffeed3bfd987fa03"
    sha256 cellar: :any,                 ventura:       "af8a97aa835cffd99a0214e95bafa9cb61d3cf34c7f0109f9881ef0ed9759d93"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 6.0+

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".buildreleaselicense-plist"
  end

  test do
    (testpath"Cartfile.resolved").write <<~EOS
      github "realmrealm-swift" "v10.20.2"
    EOS
    assert_match "None", shell_output("#{bin}license-plist --suppress-opening-directory")
  end
end
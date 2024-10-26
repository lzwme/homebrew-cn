class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https:github.comkrzysztofzablockiSourcery"
  url "https:github.comkrzysztofzablockiSourceryarchiverefstags2.2.5.tar.gz"
  sha256 "6f4d4d2859e57039f9d49f737a696d0f22aecaffd553a7d5039fa2007103994f"
  license "MIT"
  revision 1
  version_scheme 1
  head "https:github.comkrzysztofzablockiSourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71a57229b8bfaab27f073c8cc07a211558ff394905fef154d0b1ade1c6d7ea61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b82e5b008f23e3dec7d016755a3cc877daa64e565be7722e89e35cd2258ed71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7347a5d596dd15979b3befcef52dff53a354fa2acf7f64bfca26cc38f5b98ee8"
    sha256 cellar: :any_skip_relocation, sonoma:        "007d74c9daa1026a9fd5d22ed751474b203dcec6466228a860f926664c7c0f51"
    sha256 cellar: :any_skip_relocation, ventura:       "b963422707a34b8ba8eeb39129031d8bebb90b4c243b49d1a629df372fbe6412"
    sha256                               x86_64_linux:  "28c3a0eb1d8e30f1b5f413ceb51be9efe83f5b340eb986d8a98f07bdcfe125c8"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "swift"

  def install
    # Build script is unfortunately not customisable.
    # We want static stdlib on Linux as the stdlib is not ABI stable there.
    inreplace "Rakefile", "--disable-sandbox", "--static-swift-stdlib" if OS.linux?

    system "rake", "build"
    bin.install "clibinsourcery"
    lib.install Dir["clilib*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test versionhelp here.
    assert_match version.to_s, shell_output("#{bin}sourcery --version").chomp
  end
end
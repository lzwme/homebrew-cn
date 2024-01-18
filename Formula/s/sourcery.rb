class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https:github.comkrzysztofzablockiSourcery"
  url "https:github.comkrzysztofzablockiSourceryarchiverefstags2.1.4.tar.gz"
  sha256 "d4415bcb865a592bfdabd3bc2823fe64f1f9ef852b4b8bddc9c90eae9f9c6d99"
  license "MIT"
  version_scheme 1
  head "https:github.comkrzysztofzablockiSourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1ffaaa42ccd25efc96bb4056f9a61ff281d19baddac30c1d4dd6d35869d04b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af9a3ec966400a7ee5980b6166d1d9bf5ec8ba73ace9d28dfb6dc9c9f8e173cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "34c4556c9719d44b8ab08d83de6753b434a29cb1d637aed4574d8ae11a50f22d"
    sha256 cellar: :any_skip_relocation, ventura:       "8dbfa66711eb1f3c8dba6c83b36460b403f4bd8974d30501fe31332e7099e0d9"
    sha256                               x86_64_linux:  "cc327bbc34b52dbbd87ddfc2ada1fc14f022b5da078488826c15078fbf7523f7"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "sqlite"
  uses_from_macos "swift"

  def install
    system "rake", "build"
    bin.install "clibinsourcery"
    lib.install Dir["clilib*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test versionhelp here.
    assert_match version.to_s, shell_output("#{bin}sourcery --version").chomp
  end
end
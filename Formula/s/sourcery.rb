class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https:github.comkrzysztofzablockiSourcery"
  url "https:github.comkrzysztofzablockiSourceryarchiverefstags2.2.1.tar.gz"
  sha256 "b078f2c70e979699e72f2a0da106e2207fd4c3753db5a705ef6611fa4bf3515c"
  license "MIT"
  version_scheme 1
  head "https:github.comkrzysztofzablockiSourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7fcd065a98482760c3adbc6a552b584f2a533c144e5196f8f74ff241661a2b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "099aad2c7a96c99ffa1649c1e6c257cbf0759dda93c8c1c6b8ca2386758b3e06"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0ba9f0e44b49a7c627cda9f663254fb80569bfdea4cc55a7e8be1a70b1a55dd"
    sha256 cellar: :any_skip_relocation, ventura:       "b99cc6e2f77330e5ceda42d92613cabcdcb41e2507c18555507255900fba6680"
    sha256                               x86_64_linux:  "7d25bf8aebabd95ae1e781aeb2a68df052b14c1a70deaa29ba3ec7d265176953"
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
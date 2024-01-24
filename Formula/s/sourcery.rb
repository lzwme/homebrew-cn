class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https:github.comkrzysztofzablockiSourcery"
  url "https:github.comkrzysztofzablockiSourceryarchiverefstags2.1.7.tar.gz"
  sha256 "8a7aecbad4b3c2f8d0716642749b896dc6815f964303eceb3a8f2b50c81cb1c1"
  license "MIT"
  version_scheme 1
  head "https:github.comkrzysztofzablockiSourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d525cdab1a1362667227c07487d3ea7a827d8c05fda39ca4ad3d3b210ffc5a71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73f808b92afe2c650c11677f865f4fd44493862d746d4e441b1c765570344a33"
    sha256 cellar: :any_skip_relocation, sonoma:        "efbcf76a3c2f242f5753cc6ff281cd4ef0057aff05b2af43ad84b1c8f8ad447b"
    sha256 cellar: :any_skip_relocation, ventura:       "ff6d4475a20edc3371d2f179a333e16e8e6117cedcf8a299c9dcbb9a0e544c3b"
    sha256                               x86_64_linux:  "73c6813e50fb65ac806f6703a89b66026213b26b2b991d10383d4ecb551b047e"
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
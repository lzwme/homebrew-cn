class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.24.1.tar.gz"
  sha256 "ee989f5bfeba46dc53aa08568f4fd9bc745c5f8a6b8dabe3a711ddb89cdee6ab"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7766244dc367320cdcb76a42044a6886d49331f955a351278e527f20e685226a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7766244dc367320cdcb76a42044a6886d49331f955a351278e527f20e685226a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7766244dc367320cdcb76a42044a6886d49331f955a351278e527f20e685226a"
    sha256 cellar: :any_skip_relocation, sonoma:         "267197eaae2920c54c7e0875427cb1073488a72bb40fa0312b91bf3150d44670"
    sha256 cellar: :any_skip_relocation, ventura:        "267197eaae2920c54c7e0875427cb1073488a72bb40fa0312b91bf3150d44670"
    sha256 cellar: :any_skip_relocation, monterey:       "267197eaae2920c54c7e0875427cb1073488a72bb40fa0312b91bf3150d44670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eabfd9029b6df004b9325253f3a37082f0e8124c663e7e71ebe0391a9c06a978"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}moar test.txt").strip
  end
end
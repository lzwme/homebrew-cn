class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.30.1.tar.gz"
  sha256 "1e20f8a8eefb2594b57f6253e6e44b00555b3aece63a3dcf0f8e9e9ba7700d58"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3470ed23a6536219e6a587de6e47354bb2fdbd7cd17fec1402261bbb6daa8aaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3470ed23a6536219e6a587de6e47354bb2fdbd7cd17fec1402261bbb6daa8aaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3470ed23a6536219e6a587de6e47354bb2fdbd7cd17fec1402261bbb6daa8aaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4b272d4103fc814791d0f7b71dbe16477645a2b0debb3b1161695fdbf66e64b"
    sha256 cellar: :any_skip_relocation, ventura:       "a4b272d4103fc814791d0f7b71dbe16477645a2b0debb3b1161695fdbf66e64b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6c024cfbfacdcfd9147d1a3314817774a3cb18aadfb6030be84ef56cece3c33"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

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
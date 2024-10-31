class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.27.3.tar.gz"
  sha256 "323e6f645dad30bc1399f9fe9537f70288f705549ba6e7ceceb62d11020f858c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c300161b62a8e3a957c7376d6ddf0ef4f89fcbfaa7b346ede316ce8f4771b7c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c300161b62a8e3a957c7376d6ddf0ef4f89fcbfaa7b346ede316ce8f4771b7c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c300161b62a8e3a957c7376d6ddf0ef4f89fcbfaa7b346ede316ce8f4771b7c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8929ac776fa200fed9e6d98fca0013cfd963a687f3ba3486015a91bd4c2c06d4"
    sha256 cellar: :any_skip_relocation, ventura:       "8929ac776fa200fed9e6d98fca0013cfd963a687f3ba3486015a91bd4c2c06d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6044d53751b41603cd5235b8a4a3f273aba6b8d61230685c736618e6ac223f68"
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
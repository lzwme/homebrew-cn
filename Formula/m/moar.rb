class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.23.3.tar.gz"
  sha256 "995ea1a5c03b1cfb530659bf401e93d440425f19828fa3bb2f3cc211d08b22f2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae174aa677dd67ea06af971e9a91b352a2eb368a0403e07f4932a7cda8300f43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae174aa677dd67ea06af971e9a91b352a2eb368a0403e07f4932a7cda8300f43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae174aa677dd67ea06af971e9a91b352a2eb368a0403e07f4932a7cda8300f43"
    sha256 cellar: :any_skip_relocation, sonoma:         "60d189c508e22965ef43f3f5acb2240814be39fe84cee2ad41bfd4a97ee5f02f"
    sha256 cellar: :any_skip_relocation, ventura:        "60d189c508e22965ef43f3f5acb2240814be39fe84cee2ad41bfd4a97ee5f02f"
    sha256 cellar: :any_skip_relocation, monterey:       "60d189c508e22965ef43f3f5acb2240814be39fe84cee2ad41bfd4a97ee5f02f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd0eea3ad85e03d780edc9a6920b1d71bf00f496f2007c961f32e5bc56c625ed"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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
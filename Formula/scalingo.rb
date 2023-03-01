class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://ghproxy.com/https://github.com/Scalingo/cli/archive/1.27.2.tar.gz"
  sha256 "7323f29f197f412c542c3c6b2c8d232d187a03f1abc5edd612faa60a3b6acc24"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5da573f9bd6f03f50072fcb76da89cb76e64b9de19bc3411801f56bc88ed3b6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5efca423e665531312cb920cfbb09814ee869ad1df2ba465c2e3d7c49975a7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59cf0ca050685ee2249419fa66f5e846c251b77292784c40f0c788c217f2d5e6"
    sha256 cellar: :any_skip_relocation, ventura:        "27651eee2f86cb596d5b1523adadeb5f15c97ea9d740bdbda01daae5f24346fb"
    sha256 cellar: :any_skip_relocation, monterey:       "f2b2539bb5fee8581bf3d0a2430d87f8d6ce80ac0f82b686e54e07498f5548e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d65fcab7b877a827ee9453050b4ba432713f099db65395583afa2cfab888bfe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55ca60ea0f80e5f374fb9b643972dac1fb95a8c92bad38f40348bf0a0a419083"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
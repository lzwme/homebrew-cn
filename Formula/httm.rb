class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.23.2.tar.gz"
  sha256 "8499dfa6974b3e66b7602877502b17c013f8d3690e0dea7712488be5ce12bd5e"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cada6acef20bf719d6fd533d4ac961197fbd626ca762e2b76b41cc0471d38463"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c63e32d738d686dd8310befd9fcbd1c38acbaa154dea59877744f1af946c844"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40d3184ebcd7457ba705de619f370327e9f09b253c755c22bb87fe7d05ce768d"
    sha256 cellar: :any_skip_relocation, ventura:        "af1e5d3ec320605fe128be9d8cdb30da855d2b8f8f937ac701f8224415b3f17b"
    sha256 cellar: :any_skip_relocation, monterey:       "88c6c22f15b4e9b7a70ce63ac25d63b57fa14a57ba020bb57584c230b54ebbe8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b0fe46dcb8f702271dfa8a26a42e93b807f3fb4fc4139fc8eac521956ba0f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30790a4b970db13e0402d2775cb925641b49c6aff8ad9b349fc173da0020074"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
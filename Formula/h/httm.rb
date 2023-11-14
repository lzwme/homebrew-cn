class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.30.3.tar.gz"
  sha256 "290fd97ff24b00f418470dfe0607d689ea1dc8b16779bf176a606c39e0a58a01"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53da28a2b3784c0c93ce815e16c5d888399632fd19cf4fdf3f2b5a1433bff867"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e89cfa2502c2f6d146e8cb4e1a0285dd14ec09a0659a5a44a08f373d017cbbe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb7d9da3e467f0155b4bfc0a4aac845ecd7393367448e0dcae15ab165a78dd88"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed2dd5ce186fdd69570ef6abc9a9e676b1b5e156ed5806172fc8cedbd8a62501"
    sha256 cellar: :any_skip_relocation, ventura:        "71a645ce1692854cb43ab97b610b99a2ea02c10665f56a1d5977cdaebd8289ec"
    sha256 cellar: :any_skip_relocation, monterey:       "8e05699399c08368f9e52e3227c54be005a6a9e35aa273fb63b6b3712fb38417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5729569d2e18b4f1cd127d60fbf9695812f7e23e77ba044778aa9a31c3134f90"
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
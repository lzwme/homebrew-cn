class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.29.6.tar.gz"
  sha256 "426f25164c20b11cc30df4e05a76a30bd199b6fdb4b8e23535f1f2585f343c17"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b63701dc88a210c21cbd005da90edd18792e25b1f5d6d1a40899a15bc31bec9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a501d9f3bc6fd9f64cb49485363dba1515c95497655308993c57504e5824b87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb7d0218936ff354e5dc2428379fd14d412c21fdf93aa174252b48ccaa3a44ee"
    sha256 cellar: :any_skip_relocation, ventura:        "e1257a24650dc78193334eeab9c5a639711f4f99c42e4b08881b685ad596914d"
    sha256 cellar: :any_skip_relocation, monterey:       "d95c2d078b10f9ab0d67e2db78c5a343e264d19eef2d13f9076f2a4b6fff4db7"
    sha256 cellar: :any_skip_relocation, big_sur:        "68a09ade8128f3a9c364d4a9b3421f8bcfc41ae41c6783f23c81fb3e37bebd9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "192d1edd3392719f37df161730572468f519494026342f10d9342b6ec0918288"
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
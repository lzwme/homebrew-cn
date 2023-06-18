class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.29.1.tar.gz"
  sha256 "f12377191871e60164560624c0660c90090d469f3d879067189969064279d2d5"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26680deba0d129ec629412563c71823f1e70f26cce47dc30819e46e11c221a87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08474d8d6087dddbd0966d755920907dc08dbc7fe1e7cdb2e95f063b261b5dbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb0ccd83d01fab80e98ba61e4fe17f7d4a186e42dcb04968c25ba5a0b50b85b6"
    sha256 cellar: :any_skip_relocation, ventura:        "f97fd227b0a564943f60c71f9c15d3beb43e4491739c70ea6f3c9e27f070d986"
    sha256 cellar: :any_skip_relocation, monterey:       "f50419c424bdd1e34a5863eab92cbb52f349a12b445ab2c96b3542326d1cfa95"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb2f053b0240080218ec2fa3ad442707a5c3794d3467db4b4a7ff4b43ae26fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9910cca16edb48909837c9d0a29d65f096482b32a658892cc4ec3d11f7dc8fa"
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
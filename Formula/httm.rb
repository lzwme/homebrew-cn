class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.26.4.tar.gz"
  sha256 "b376deb74f15075bf0dc08f28b8fe84859a8e6a1737198aec666ecc8c9c1aa0f"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dc55fe914eb0819731ac5d12a71784c4e9de93d8f1c42885534ad5be772ba21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4126c54a934c89ec858cab51e3c8b3c9f9418f27443969b1946223e51c72850b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb051ad4568b555fc3ef1b66083d96983d19d794332a63dc11bf7a1e90726556"
    sha256 cellar: :any_skip_relocation, ventura:        "3e18ae38bcb2a512ea512831f48c77b01795e9be92092caf2c0ec2a3d5b1ae8b"
    sha256 cellar: :any_skip_relocation, monterey:       "3d79413c200ce9b7544927ed418fad1976e72b874f2acf1c31b47414325c057f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c721991a8c1008d323869b3f1bc9f473f33266b9483221b831d1d991ec67e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9046550cae8617f253d1fc53c4ea73fb9d3c5c15f28a7e68bfaa04a95792f4ef"
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
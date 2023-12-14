class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.32.5.tar.gz"
  sha256 "d5653fb6433b1371ee47d154f7f08a997de46f11f6627bda9bad514f7c7e8bcd"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bb452d56346d3e913e182165ccbe8546b90ad547f89bf76228f77efd8ab2d96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04fde6ffaa876c80e84cd6cdc20984b20d6994bdc4c47674d6c8629f9ac8e8c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab447e0b71bda20b0edbbdf8577479d69b62e1cb37dbae2e73d280abb9952527"
    sha256 cellar: :any_skip_relocation, sonoma:         "0561beabba088e7177fc51741e2b626c539c3482de120f597578d5e28fc4b51c"
    sha256 cellar: :any_skip_relocation, ventura:        "9f48426e926773ca6bd36972fd03c3369535dca8c08e617108e9015ac15ce75a"
    sha256 cellar: :any_skip_relocation, monterey:       "7b265176aa3c93fdd01080c16715e4acfd2f7fff03fba2bc2b21a5c7fe89ba06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a84498e48d979b3c60784bb7a1245824c7c9b4173a298ef0caddb95217c2e652"
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
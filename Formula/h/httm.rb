class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.31.4.tar.gz"
  sha256 "b912cb1f820a3df488a28ece4ac22f87bf10ac199bfe7e1a1cec478476d23a75"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe5b684b4efc6c0386bde5e0284e294381f28380e21e28c02860f1881fa277f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0258f32b42108e23ba3e338ebe8823ea2cf8c9bf7750ec12e934c211d49f750"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcbe31c4db9eb9e1dcc4bba8d7b2ddbe25a72f61def7e88d124f6df32758a3de"
    sha256 cellar: :any_skip_relocation, sonoma:         "42245b5ffc651314a9a7e4183fd19a39022bbc66f6b61aec13bb2ba1a36f3be0"
    sha256 cellar: :any_skip_relocation, ventura:        "6013b69663d4e57b25956cf6396a51ca9244822c4236b9cc81a998d22e4c937d"
    sha256 cellar: :any_skip_relocation, monterey:       "6940f8d3100b82c462777b97aa406c2503f0f9fda0ef991ef3accafb64f9499e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbde393cebbff9bdb097dda007749bc0841d6cb28fe14e3329458880d4791623"
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
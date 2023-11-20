class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.30.6.tar.gz"
  sha256 "d1a1e88fe9a4acc99017b1b397d18383c378a232d2782b4f11f443bef1608588"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4485a5c5f61e9e159fb4ab015596890db6dfdc6e208bf6a768b16472e6afaa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d582d7f15ec8a73515b5b7111c9a84d0803d455820806cc998d2e26136ac740c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb51ad5959c9f4913249657748cec2ec49ed22f6a0941535bd21640693717e5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "639e0a4faa3814397942b033160764b4ee3cdc5c213f5858f937e8a25d9441cc"
    sha256 cellar: :any_skip_relocation, ventura:        "f5b8eb8bd560fba8c4fc0f77b97f5ebd2f4bb684789a6c78babfc4678d48c69f"
    sha256 cellar: :any_skip_relocation, monterey:       "4c5bb8b1b2f2ea1fbac01f409494ecc2cce6426d4d0886eac011c186b9e7104f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af71c002241e9982e1accfb7d312b59cee9198f00f80b8e2bbc236f79bbd111f"
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
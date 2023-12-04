class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.32.3.tar.gz"
  sha256 "6958420e9f95a374e79b15856687e40e5d084bd804343c7b02c8416f6633178f"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b71e9c0ec4ecbfe6fff177059cabc0bea6a9dcc58cb5267acb4ae3e67b5b7d2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80cea035661b28a96a5da554290b49582a7391b09f0ba82cd229348737b72d56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd7bd989535e4364e5b5238202f543e68f5a84434aaf7096d648e5779f6cddc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d8fcbe9ec9e54da497678df81ffd8a92eb02b17333c96c99e2fbceccfb6f97e"
    sha256 cellar: :any_skip_relocation, ventura:        "98d73ce7d0f10b05f2a9a09627df4d4dfba5fb2909ef7a0bb0f56c23f04a3fb6"
    sha256 cellar: :any_skip_relocation, monterey:       "91e048ed3e0529ea1e1f605e3c67df1c2eb9ebaa0abab28378ce91feec76c99a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45df1386f8126b410770ef0a79046bc29fe2745205f6386342252add5ccd659f"
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
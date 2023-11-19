class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.30.5.tar.gz"
  sha256 "69228521c8f6547c98cccccee440ef938f023fa7c34f20f168397c78f27c7b7d"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c99481881b86067d0d7ab918bb83ce8db194d7e6e476099d79c04021bdd6bd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3495c63c1b3aa33c5e18d438ba92b7187616fbb5ce9e0da7d79a826a696374c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8187b35249243f19eacc67531bd09928e9f0c2466a85e222f23dbd2e6310ab9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2931e5b127d1e66d4005d1e105158b1e097fa8386bc4363143881e3569e0097"
    sha256 cellar: :any_skip_relocation, ventura:        "3c8877ecb7b143b3fa930e721ca6aa6d8bde03be72f87b605359ca813fd275a0"
    sha256 cellar: :any_skip_relocation, monterey:       "ff406349bcabdb8081d09e163feb3d2f705a45b711ed8a644b115525c9f3ceff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf315843c7faf77ceb1c2a36c949c76926017cf227eb8dee598a9c36d6800c24"
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
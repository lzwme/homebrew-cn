class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.23.3.tar.gz"
  sha256 "f7f04ad4f797a4e8b1f1ba581d7b410be2a0eea503a65f4c3670e04a2803ec9e"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fff38584aa615b900215d75b9c8a92b543f388b53c98eb9a3dfa6809ee49b53b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa68d97d455d00fee9477b46a7b86837430411aa41daf06f3dfec44fd326189c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "289194d565c96558cbe7821ebfcd99ce6c67f9fdf22bcfc8df2ebd3d7c3db56a"
    sha256 cellar: :any_skip_relocation, ventura:        "4e2425793e8f953bdd14e6c7ca5e00e1b9010900119362c661fa735ad04357fa"
    sha256 cellar: :any_skip_relocation, monterey:       "870b22064fe88b44a07439a7e7b6646b5c9763bbf2a53df9f60d44e1db18f0f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8ea0bdc631f29da937b31b18b81fd7a5cf04510ab8d1af3006bba6121f6f105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "057cb3d5f0b42dcb23f79855e595dd0a02db642fc99dcd67a454def5feef8282"
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
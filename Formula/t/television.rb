class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.13.4.tar.gz"
  sha256 "fac150db827435650db28c3e6ac304163542c8f299e00b10457471eeba85a06c"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0f1ba4ba2a0e6c73596ad34fa51cde8611c8d83651394884d644334302122f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fae73d68f52a53115c94255713c0d1c44625dc89a4f9ae5e2fc03d1d6f4e412"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91ad6a7f5b3fa8db4d47a1fd1d8ddc41c13f497a352f6b3535f7488ddaa9d773"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d53ac07dee6e5d4b5704379ecd35d6b989f1b6f72c0cbec45f02d60a371f34e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00098a2de2ed73241cb6cb719fe54cd5e10e7703b732b0b3d9e0d387ff22d0a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "829740420fbf46234c11a815c016556a84c91b38ca0d40b6fc6c6671f419af3d"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "Cross-platform", output
  end
end
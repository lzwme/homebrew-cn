class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghfast.top/https://github.com/kimono-koans/httm/archive/refs/tags/0.49.7.tar.gz"
  sha256 "6101174cc7938f00223c340f9ff1b790593c4b5068dffe15ea63dfff9874ec3e"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e87076520a69d7d06d8abdfa810699b4055a2d9e2062b05f68d5b10d8cb4372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a751617935035fd52ac1639a8dc5f164466bec70ef047cbb86aadcc436d75d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee27f0e6e2a04bcd74d671dabbaed069b5bdff714bac3b45da2618d4c23fe2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "55ce2d621040055812cad07a4a34c43d00ae21a732ff373073dc7169ff73bb47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96eb9e540d1686e43a76acbd0ede8eb0a228ff43acb7ed965cffe9a6416cdfbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ec97b382f82609ad50f07b718a9a5b167de6fc1c2bad0e6b5267a4681b44362"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "ERROR: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
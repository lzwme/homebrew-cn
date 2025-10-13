class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghfast.top/https://github.com/kimono-koans/httm/archive/refs/tags/0.49.4.tar.gz"
  sha256 "3d55618c1092d7da21af665c5e9b82d51582519443e07774eb5f5dad8d6fe59c"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1026dc30e07a83629766149a422db53c5be677e15ff5104b7cca286e5cc6aa21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1712ab58eefcdd9c1dc3a384741fac5d771ee7f5a0b9e8bd3eac2bb394f67f2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2008d1d805483e5fc694f8854f0c448738ba8563fc3237c4173d6c07632b850"
    sha256 cellar: :any_skip_relocation, sonoma:        "c94e4737eb0459014c9fddbdb500632c9a0d5b9ec0202522556f4f7c7f11d996"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea8b7d1308215fcc2940fa6ce1bd9beae276c6dae1d858b00bd921b25cc7af08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df6a524aabd1354999c75b188cc249255f1c1e6b15dbc0ada686cd8244515be5"
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
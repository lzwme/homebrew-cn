class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghfast.top/https://github.com/kimono-koans/httm/archive/refs/tags/0.49.6.tar.gz"
  sha256 "ffb2f74374bdcfd1bc969b6761b61c19e2fe44042c6445f61393c3aed0241b8b"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df6ebae4f1ebbd9b70e5dbd822144635d764ea9aa27df30296b978abb74bf9e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1fc63975b3f85462afed2fd286df48e8f4458b4c6f5e8072a417e1b47983bef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fa82a96ce5e30f397a3cf6b82357ac398c77e87209cabd8b7b02e2205a222ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "157fff5fe4107e391e8b457d925df81d1ad5e03ad0b2cccca038bfae170396a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e384b82328f62cfb3d87750e3fe2decd7d040ae5e2a7b960e2b0bedfecd5da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c6241e6a89d08e2b5de0343071ab2b8c5f302c06ef5329e12fc46e3f9235d71"
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
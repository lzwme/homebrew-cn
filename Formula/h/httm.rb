class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghfast.top/https://github.com/kimono-koans/httm/archive/refs/tags/0.48.7.tar.gz"
  sha256 "69b0f79cbb195afc5f2be5f62f42be3f7ece6971408b864df5de597e5a0732a2"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15ff49d4c38f12e0e7f7ecc318142f917d724c841a55b8242a422310e7460261"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d56ef695373d97ad8b04eb004022bcba254d87b4375c4660b77905dd65ce2c34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4f78eb85cef3d527b5bbdfc5ac6efc1fa33d015aaa19e9403f5fb8dd056eb1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e4944f73f84c7aca1bf683b3c92b616fd8af0f2f42dc2a1f2eb63b544bb0ace"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "376636d23d120f4c1035bc946569b39399ac6d61a152c08106ecfc9c5f98c143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8efbaab67b6c98c221d7cc5c0b07c6b5d84d30fb752b752a70884a008b9f157"
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
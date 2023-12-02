class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.31.8.tar.gz"
  sha256 "8bb37e5c3cb12b471f8da704dbde558fda5076668593de8c0e6cb8db5ba299cd"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "565a0f4f21fec3df95944abc48056a0f36ede3710134038173b6d28f9a1b2817"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5083e1d6be5e43a5d392100055a5cbff938251778c25f85c23cd8e2ff680083"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ad125d568e59fab4345b4eef054ab101070d94659a77f0e748e65deffb4139e"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa5282e69cbfa03103918a7b126d7f228dce22548206e98fc85104b43c10b392"
    sha256 cellar: :any_skip_relocation, ventura:        "e86e8c6f9ab58768b44d18c09bb603103267e1f29d7ffcddd2150ff4585f23f5"
    sha256 cellar: :any_skip_relocation, monterey:       "642e4cac88a691bbcd495a7b76c6ac9dd46631d1d940c698dbef43726d0f5710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c82b41f395cba8f6b8b127e452db66327a11023be9226a2749c4798f479b55c"
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
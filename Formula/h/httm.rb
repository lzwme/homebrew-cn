class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.35.3.tar.gz"
  sha256 "f09862f1efa0c01c5603c36036a61f2a71fbc00290e0e7346a8c83f810e23745"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d25504a3c153a1403976eee3a63d22099592691eae3bfc49822d2c3c95fc7d01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1b0cf4379d62a8c12026edc0f9877f28ddca1544d79e65ef3354442ed3001fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a87c68ce7396e7caf1d3321f23752f8c3b2a148d06a55556e41afff5bd0cc3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cc6687c151a1a18c060ef8e85d3a2e3228ef36820e3b69bdc89be2be52a8a18"
    sha256 cellar: :any_skip_relocation, ventura:        "4a84f89262d5c6710edbbc5a2061c8846a29d3d11a0d12a92a8c81fa5564ce05"
    sha256 cellar: :any_skip_relocation, monterey:       "f3591371230324146ee926eda1638203aa6121a7ddbed7fe7ee17d62bb0bad14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a31df580ea4f577ff349517273d57266f74f1d89bcbeab602046a7b3ae016dc2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scriptsounce.bash" => "ounce"
    bin.install "scriptsbowie.bash" => "bowie"
    bin.install "scriptsnicotine.bash" => "nicotine"
    bin.install "scriptsequine.bash" => "equine"
  end

  test do
    touch testpath"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}httm #{testpath}foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}httm --version").strip
  end
end
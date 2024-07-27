class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.40.3.tar.gz"
  sha256 "b61997855a97c48941075f84f7c49cd68c40140c5d07d22cdf671a9a0fde593d"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "114a255a1233f14649513219df01c7f2d23e7b2078d2b55274b7ac1408c650b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7fab369f7de3d839a4a0c4962c1e6593f8592e033ca7a8282c4d516a9f913c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "634ce988001a48e5e12f00b485922d6d4fcd8374e3b3103230ead9c5928f098d"
    sha256 cellar: :any_skip_relocation, sonoma:         "49e09ae2b809ac4e74bd122953b9b8bef85e26cb630633c1280866f0d4315fa4"
    sha256 cellar: :any_skip_relocation, ventura:        "306c3e395365374caf605bf7c5ea2706f83322b5667b5374a9564f14734d7d1c"
    sha256 cellar: :any_skip_relocation, monterey:       "2b63a54a03086cbd0d83066fb9d696bebc6c9e796a8e76cd93205b43522ceebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4bbe609e31d83c1449ab27dfe42f26df435715ae4dfb0b7b5c998311a747d05"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

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
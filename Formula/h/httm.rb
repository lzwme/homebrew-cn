class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.41.5.tar.gz"
  sha256 "bf9c3c095b8986181b615f6464092ca4c1e151efb16e7e70a13c736764905341"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73dbdc7e4d1556d5171b3d7e446911e925d7df15ea5270ce618b5511893e1c1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64a37baa9ef31f8ca4dab4b21ddacaf98a8916c40836af029eee9389df5c2ae1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f56accf6de7560033c69ca1a9186db5ff8eb242df6f68260e77666e6b02554a"
    sha256 cellar: :any_skip_relocation, sonoma:         "84aec59d267d63df8d5b809e3114cf8a4605ab22fd654d9ff3ad60a97dc00064"
    sha256 cellar: :any_skip_relocation, ventura:        "2d948410e11d6d2dc5705fc03ee88375f926d8b0ccd3e8a1de465ddb4a622e64"
    sha256 cellar: :any_skip_relocation, monterey:       "bc068b3208878b39379908c962e8a349a2ddb6706a9ed2576b8081bea734370c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a37e85f7e028b9356cf3d83d97f08ae36594ed6a005face0f82d634393c6d361"
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
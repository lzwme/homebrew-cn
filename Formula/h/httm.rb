class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.48.1.tar.gz"
  sha256 "314f11b400fb87f50d47dc341448d71f44e62d2117a7ccb2f2b948e6983f45dc"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c63277b92441e802ddd810d962a470eab0056cf617c9a0fe28e1da6d3af13e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9520271ad05a88104aed251a22dc53c56bead23b8c4aba642a9e3896d0be1c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "654bb68f973209d396ad66352de2c3c4b737785db8ac30e0ad45b9c223dd2144"
    sha256 cellar: :any_skip_relocation, sonoma:        "82c6cc3dbf8104924655953da7bd6b42f2cc98896acdc1aa1046c04d7da979a8"
    sha256 cellar: :any_skip_relocation, ventura:       "a1fb4fd87744d71f75fe671e995348647c172485dedde754dfb5e6b20bdd9bd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09ee448fec641694d95e1df884dc59826301ecae536fb5bc727c8b2d5ba57d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd381987b25c8f68a3d0b1fbd387e31fcef72b4d13bc50a38cca0cbeace3a6d"
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
    assert_equal "ERROR: httm could not find any valid datasets on the system.",
      shell_output("#{bin}httm #{testpath}foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}httm --version").strip
  end
end
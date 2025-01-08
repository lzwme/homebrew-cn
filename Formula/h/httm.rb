class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.44.1.tar.gz"
  sha256 "8d06f174a51312e1cf5a5ef6c8ed921a5d64e82f2bb848eb5614b251b9275f69"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5bd60064a162f3146ac1cafd74e36c375caeec249f65c29a2a7cbaa86fbba20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a27d2042982921a76b5f342efa41eef86f399414c9578f54b826f3029734f7bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cee73e4ebb3209f6d3777285a73b3306c15a64b055a3f989edff3d1ab503f17d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dab34df3936ab58ed41f68a9ca7c4c60e3dcea198fd4d998ab89f31d51a23016"
    sha256 cellar: :any_skip_relocation, ventura:       "5e849c3e7a2d97765efea68cedd1106f7afb68411872eac9c046f7c40fbd41fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0fcb92f0f8b924a7786bebdd446354b8d9b88637c49d04f165a4853f1d2c8d"
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
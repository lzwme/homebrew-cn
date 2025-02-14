class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.46.2.tar.gz"
  sha256 "bee10688f3ae885a68eec553cb0258f45d0934545ef7b6d309c035c55427bea3"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cb9b553085997b0bb3eda4b3cdec58570e21e5f2bb9e67bc16d791a48e82c61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76cfc2e378ce263168ff1eb1d9fa813c43002e5101bf8c63779e24ae77d9381b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62d6888c79b22bc1fbeaa9788d96a496043e2bf29a99ebb52836f36a69ae7e70"
    sha256 cellar: :any_skip_relocation, sonoma:        "90e6925c5871f44f133f2861707b5a2ed9b481f61668fcacacd1f73e284964bf"
    sha256 cellar: :any_skip_relocation, ventura:       "7fcb83f2aacbfc4632d06c61aa21827352f5b81499affe1fdc2dbc1f15bf3218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67ceccaba8e8ea44b50770e45d49e34998f2684640d84e3155e2049e0b0eeadd"
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
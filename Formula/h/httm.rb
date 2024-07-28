class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.40.4.tar.gz"
  sha256 "61d1b9d2c0bc03de58bdced4b04ebbfd4f3a173a2401d299f2525ef504d63b30"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfacc1489733345e215096f08caf48e9d00616e42af3ca9c65b82c5fc0af1b6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a3fcdd5f565349a50aa8e7de63ac029082c47559745cdc5720e1811f49961c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c58e880d0a9f54434428b4d5e9581ed1b2563be541badee9b0d1e705f75cf103"
    sha256 cellar: :any_skip_relocation, sonoma:         "333ca22b31de2be1f5c16d35e328824f9863bf10554c6b5f48e06f951b9edf45"
    sha256 cellar: :any_skip_relocation, ventura:        "8b70ba9eee9c706d4cfaacdb0e50d7519b062aaa941b2728808744023d1a1c39"
    sha256 cellar: :any_skip_relocation, monterey:       "a4e3ba990087bf138fffbcbddaa68fd045d0c4a9c2f4f65fd7eb2ab2f56bfec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a672066ab22de9bd4bfd09e1fbdef0b3923f8d435f7b41e808c97c8a661d6f0"
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
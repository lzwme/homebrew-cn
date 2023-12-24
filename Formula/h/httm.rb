class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.33.3.tar.gz"
  sha256 "cc6d6f9a0739fa7678f3a6f3b295f03eac423df6a6a0975d76f5853805c39b16"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fadc8cacdc09cdd881fc82b3439b9b7def5f881b62545eb9527f5c2b18e82cb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8438c5b616e285e90b79274e30d6c94cf0c5a1efc66f7affa64c11d38822d335"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2950547084199d079b77667f5d519694ea6deb287a2dcefb3a7f47c53fc3d94"
    sha256 cellar: :any_skip_relocation, sonoma:         "463cff524ce44e1d8358e9f80cc72011df723269a052aed2eb66fa5c92b5b80a"
    sha256 cellar: :any_skip_relocation, ventura:        "791ad0f973c74e8c36c6ed4c403c896d428cfdaa2843511b61656891a2e969e9"
    sha256 cellar: :any_skip_relocation, monterey:       "b1118d87b1d198df9cf69973641495934a045ef8fcdc835eed534e0729c0883e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e90f57ac0103822fd3aeccbfbbb6fb5483a079eacc3237491cea6e3975b70adb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}httm #{testpath}foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}httm --version").strip
  end
end
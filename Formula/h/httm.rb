class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.42.3.tar.gz"
  sha256 "b4c874358fd9c590c5f41abdc2651c64681f2bfab160d7347fad3eec5ba81769"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "764e791370c7b3aeb0e5a2af366c8b019779b1806aed31559bd8e16038fe2803"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24940cc450017366b048d5d7c5f4c3252a3fee6b90156ee2fbeacb3153e4015f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fd978d1e45d30a8b07009703e7fb85877a58b0a71a3f3a3de5b040eb56e2cce"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa2c79a395058801d515bbec97415df6ab1e3c610fb40b968ef595cd5b3f9f7e"
    sha256 cellar: :any_skip_relocation, ventura:        "085f87edb566339f882a17cae529b260c01e51d48b2a6879660323dea3c90775"
    sha256 cellar: :any_skip_relocation, monterey:       "373453a4ce10c169ffca9f092b7a5e93d3c05ab128a313fbe3372d24618c1ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be5f27a6c76af9f5e2b509f1b6c6f4c3c1c13d0edbee9842021d9d1112aa9bde"
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
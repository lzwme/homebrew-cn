class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.48.2.tar.gz"
  sha256 "53c844925ebf9fb034590e957281a1f3dd4d13fea26c9666aa9d54e72e664565"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2df9bbacfca7a995fa4d1f1737531be60a6f5bb88e1ebe9da275b872d6786a62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78cdcc0abef2139f18de5784260308b890df3a4790906edbc7ea07b1a0375df4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96b6445226f2a5ecd66ec8b1ae1dbf3538a6400c7f17805348caa8dfc46f2864"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9bdd149494d268947dca27ab4e39824bcd47a5190d418a2d5780b790057643c"
    sha256 cellar: :any_skip_relocation, ventura:       "948384b821b44fd64aa5e62fa789844a5957320a70da20869ef23a86cc15f00d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb124b8c0620d15a9d2f98d9c1f29275a171958a5c5c354eac11816fea68d3d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fd6174b0d98babfc93791899a2b55e976489b5162cf56362f66c1db248eb60a"
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
class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.34.4.tar.gz"
  sha256 "f2abf3f4530623893a8cff6e1434d2b9b5a9541ebfcec42b03574a5af602fb38"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9cf01731590ef6bb02a467742daab19f48bb29b01ebce0d0450f518fbd44bba4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cac637304139b0c55ac9ae2b184e4ee21f2da3873713eddd96418f50aeba463"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b1db179885502baabd4cde9e94aca4efce872491743b00e74a52bc8aadb35b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "56616b95de1d2476ef5bf2ca4599bee8a04951e2a7211dc1c750032bee7eac31"
    sha256 cellar: :any_skip_relocation, ventura:        "74a374b3ab0a30456a2fa00aa0e13cee2b7857da76affd919a452485d53586db"
    sha256 cellar: :any_skip_relocation, monterey:       "556a284a9798b0126f4f7e04fc0452bdde7010b3bd2f3387250b304c37104fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "305ca58801dc12887a265e65e162d2c7b5cf60bb43a6f8bfa942bddfc7405bac"
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
class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.41.2.tar.gz"
  sha256 "8ec6bdd17a314c728d7dc19b39de1106464713f753627f9a2c3277cfc2d0c695"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da0b11cc0e1139cfd9aa27d9cb916a661263c91f8bb2095680b66f377d3f6849"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ef54a69b788652d480a7ab57bc34441f734fc0acdd1dcee9aeb60a75cda8884"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ba5a6b8ba1ab5ca4469f49e4a224d437c44991efb6820a697839978274b7382"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bcc3cbf5bd8440395690f072493443c7c338d0493a85107a1f48fd6258dc026"
    sha256 cellar: :any_skip_relocation, ventura:        "2b7e8b22f1b6af039d50869db94e4df5d443a6eb5756a526fcf25f69ab41b0c9"
    sha256 cellar: :any_skip_relocation, monterey:       "47edfbfc31ae0f29200ab69c0074c486162a9817f226cfb85cf8ede6dd195a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e648cdae64498c887f220156975346b3e6b0fc49e4814e689aed367f83b7900e"
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
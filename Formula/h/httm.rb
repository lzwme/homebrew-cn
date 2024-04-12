class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.38.0.tar.gz"
  sha256 "97d5d0396dea4d914491c21d04c14bed2d791a95920f88bf5c5749aa36b24b6c"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81dbf9ef206a1f86b4d8ebaba09bca477a8b097841eb7e269e32ac152dd992db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "462b369f17d703c7c50c91fd35bfe8ed006cdc8c12808c5e5736f4be56d124a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea8707db64d6ea9934a821aec3318f1e578c47ae4be9911e040f897028764b4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcd0c7c565a537be7109420f6428a134ca3c2d0a23a0f1f805a9e991ffdab90b"
    sha256 cellar: :any_skip_relocation, ventura:        "23c600bed93afc0e879f028603d096599772eabf16647fc936fb05aa7291f606"
    sha256 cellar: :any_skip_relocation, monterey:       "ab855a552b015736acd88501e2adc0a4a083a566a5146346bc6d3de85d46938e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6ba43e81ce8755052409476bdf36c024204bdfe045b5eb90d42ed8f61812af6"
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
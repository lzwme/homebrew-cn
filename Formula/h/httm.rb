class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.42.4.tar.gz"
  sha256 "f2d811afdae96c04935fc61f9ba3e1ad28b1c85fce148913ff06a2ab66b06527"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e5295b8c944ffcdec1e3ee1bece4ded8205e1523c68021dd8d26dcfadd28d2c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "598fb42f47ce2425289a53e5417ffbcf01bc481d4567b5e3f557c325302d6676"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8b8ad5b476e81c8052715ab859b6181e8424503292bb035b5dd4c0be3a2f28e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "357b950d575b81231176f35edb389045f9f795c83914297d2f10cb5ef792ae20"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e79d0afc67ddbe99d1f7d896afa1ec186da86487f330ce069ccb1609265c1f5"
    sha256 cellar: :any_skip_relocation, ventura:        "900eb35739951d0b34424ab01122faef3a11902387b4b70f3f010511b19685dc"
    sha256 cellar: :any_skip_relocation, monterey:       "4b2804cf74c5f981b9ef9bdbafae60f9f2259d3d3c39ff717a93723d6046d7fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddb20f055add8a4583e77c124bd04426ef0d20ebae790eb71bd229cae0a73edb"
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
class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags3.3.0.tar.gz"
  sha256 "060d4ab9ae950efefc48df2604b3b35409d2e6e88e573d63c1dfaa36410a32dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "624705d1be23b2a972d80c9720f2eb574bd8fa75f999de6f7e7cfdee25d4a0ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06cc125fc4b4e9420824e8ec513385da90b46c71981253095bef5d23153b1e76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2da29e5ad355e084793aef8f07e4fe2d80628ae48acd117a189775a79ecac9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9d4e7e0012469fa199aa7f5df291bc8873cc7eb78e86e76b54cc0501877e25e"
    sha256 cellar: :any_skip_relocation, ventura:       "25ef2041b88be6561a77bda62e014ca91e5d86a9081da8e3f5321c1999793edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a2ed8761931697d17219a3484d53e1971b1053bb39dd5154fa5fde7afb0091"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end
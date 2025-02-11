class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https:github.comkoki-developgat"
  url "https:github.comkoki-developgatarchiverefstagsv0.20.5.tar.gz"
  sha256 "0050adf7c3d70322f43acb667ac245bd65e687895eb0bf81aeee436b6ab2a2d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b81a1946424b2ea38e74ed0c3bf7d9ae685752ff0ce5bf287e8f423f3a045066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b81a1946424b2ea38e74ed0c3bf7d9ae685752ff0ce5bf287e8f423f3a045066"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b81a1946424b2ea38e74ed0c3bf7d9ae685752ff0ce5bf287e8f423f3a045066"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e7719c3ad720df92379ebc51e616a779d2567f26304296ac85835db5b118fa8"
    sha256 cellar: :any_skip_relocation, ventura:       "0e7719c3ad720df92379ebc51e616a779d2567f26304296ac85835db5b118fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bb0e36e0bf97ef3e32884417fb269b6df886f9ddd89a763a1d34fdb61771537"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comkoki-developgatcmd.version=v#{version}")
  end

  test do
    (testpath"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}gat --version")
  end
end
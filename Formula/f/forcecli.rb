class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://ghfast.top/https://github.com/ForceCLI/force/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "a7dbb98ef80e2a94a0065e63a37115a025ba8f6b97a19a1ffb63c4264dc790bf"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "782c2f9066c57f9598d3aa9f17544a401732cc84f1284e70aeadb7b6b1cbb281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "782c2f9066c57f9598d3aa9f17544a401732cc84f1284e70aeadb7b6b1cbb281"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "782c2f9066c57f9598d3aa9f17544a401732cc84f1284e70aeadb7b6b1cbb281"
    sha256 cellar: :any_skip_relocation, sonoma:        "aac768af1f98d9d238cd99c817999eea72eb80293385df56f1f70154cde1e583"
    sha256 cellar: :any_skip_relocation, ventura:       "aac768af1f98d9d238cd99c817999eea72eb80293385df56f1f70154cde1e583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d89018ab68f977a6b4785f90cdd74a109a21163b45ad20ff55746fc20949e236"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", "completion")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
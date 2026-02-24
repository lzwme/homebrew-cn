class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://ghfast.top/https://github.com/ForceCLI/force/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "e19fa6d352893c43d1ed6c4b74f952a1d2a6e069a906260650c9513ddba1edda"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e6db49d19b0326a007ea0b1893e9dd175aae009b53e6f51f1ee693e5a9b2062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e6db49d19b0326a007ea0b1893e9dd175aae009b53e6f51f1ee693e5a9b2062"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e6db49d19b0326a007ea0b1893e9dd175aae009b53e6f51f1ee693e5a9b2062"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f8247fcad6c54ae86444a8de95f40b800515e4f7362de9c26d5e2a6e571fc55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de22c3e7a416c9d04110e412263f4d68ed3ac048fbb07517afa3c583da473352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be6f218adca654abe1c20a77d250002d4360c82cb53751e628389218e9d46588"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", shell_parameter_format: :cobra)
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
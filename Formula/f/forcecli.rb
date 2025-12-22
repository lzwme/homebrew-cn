class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://ghfast.top/https://github.com/ForceCLI/force/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "2ffa9920e9577aa0e351d1703db3a450f41fc5d55117450e9a9ed2b983f0c5b9"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72d5fdc717abcbd611e35be1badce02f19b84e69ef0abdb92f865cd126c8cc28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72d5fdc717abcbd611e35be1badce02f19b84e69ef0abdb92f865cd126c8cc28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72d5fdc717abcbd611e35be1badce02f19b84e69ef0abdb92f865cd126c8cc28"
    sha256 cellar: :any_skip_relocation, sonoma:        "a40837049f7146307dfddb783066edabe0dee226525de81191f8aafa7120ca83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a770ce58616598bf44ea7d8038ad64e6d00c9bb3ba0bbb1ac7df61544f846022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afe8b07ecfcdcc539d531885d7fe671ae86e645f0ecd82782b040022974f6488"
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
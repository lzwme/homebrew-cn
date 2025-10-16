class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.34.5.tar.gz"
  sha256 "175e30ad61a98f43040608d4a3761350b3e512b5d46f9664a2df563d1ed7355c"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d18e86191e6630668ab88ee0e87e89ecf599abba6c40f382f432cdc8dbf9c509"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d18e86191e6630668ab88ee0e87e89ecf599abba6c40f382f432cdc8dbf9c509"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d18e86191e6630668ab88ee0e87e89ecf599abba6c40f382f432cdc8dbf9c509"
    sha256 cellar: :any_skip_relocation, sonoma:        "964ee44c76a2580341477d8d66ac602b4c482ac9627541adcc1b1b13e6142273"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f04603dcbad011c36636b3b3e29e424da9a0b051d2a93f01f52ae90dcf4b411a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0d93a5209e98a78e904aac29994a94881d9963b49006676d426fec54779d25c"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"bitrise.yml").write <<~YAML
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    YAML

    system bin/"bitrise", "setup"
    system bin/"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
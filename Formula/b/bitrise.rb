class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.34.1.tar.gz"
  sha256 "71a5c6b93687970d224e57eeb621fa820fcbf838cbfdc81fc8697a2b74483475"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4814a097ba2d3498ed79909b5e1f4d2f68bee141c7f6563a8c4f71fbc2295db9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4814a097ba2d3498ed79909b5e1f4d2f68bee141c7f6563a8c4f71fbc2295db9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4814a097ba2d3498ed79909b5e1f4d2f68bee141c7f6563a8c4f71fbc2295db9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbeba2f1a30296acb31bfdc55ea408ac21a2c603e0fc3643191fe22e33cc6c85"
    sha256 cellar: :any_skip_relocation, ventura:       "bbeba2f1a30296acb31bfdc55ea408ac21a2c603e0fc3643191fe22e33cc6c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84adaab54a7804630489ff48a675b9da0a5659c0f7d41e434a2b2bfa905d9b74"
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
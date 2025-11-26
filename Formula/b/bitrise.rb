class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.35.1.tar.gz"
  sha256 "b0fa6d563a6080d107f242cdfc5548adff4348d4d303e8b461610992ba8e901a"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bf93df13539bfb7306d1acf4a88211165db45be028dae1bc8bfc9e4740cbab2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bf93df13539bfb7306d1acf4a88211165db45be028dae1bc8bfc9e4740cbab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bf93df13539bfb7306d1acf4a88211165db45be028dae1bc8bfc9e4740cbab2"
    sha256 cellar: :any_skip_relocation, sonoma:        "005a8a8349c3b29d06eec49bcd9cf83a10443dbf6f6a6a541e38353299c1defa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b37b54118da834eba06d7ca557398167bcfc9b6561e7694dd069667a962d3fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f19496f4c0c5761e0756eb1c9af48505955ada9d37c86033f0591c8aa41c48df"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
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
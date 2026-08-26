class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.43.0.tar.gz"
  sha256 "3ee538274981582394e6e30bbd38611c7b929e1aeb7a8251b5cf1d2de381e38c"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f15945164306af94e2ed5b7dcfb5e8d12b40762e5761136644518ba37d9a7450"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f15945164306af94e2ed5b7dcfb5e8d12b40762e5761136644518ba37d9a7450"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f15945164306af94e2ed5b7dcfb5e8d12b40762e5761136644518ba37d9a7450"
    sha256 cellar: :any_skip_relocation, sonoma:        "372790bc4d944366147d56aacd563bf3fadcffa653cadd8e1e94d62f75f9127f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf4cf483339abe40784e3099e756db814962c1a9240ed583befc7bc978ce8418"
    sha256 cellar: :any,                 x86_64_linux:  "6e6be5124254d0788f5c3955fec94f6fef669b747082fc91be831adb0ef5609f"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bitrise --version")

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
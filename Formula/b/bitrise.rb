class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.27.1.tar.gz"
  sha256 "5fe8812501f27c3b32f20f241301ebf8e179da89148dbee48a0acca6ed66a6b0"
  license "MIT"
  head "https:github.combitrise-iobitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb8ae69b5e4228f01ed99030c89e2f14ff4c9b265e074c2ed708d63b36264fd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb8ae69b5e4228f01ed99030c89e2f14ff4c9b265e074c2ed708d63b36264fd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb8ae69b5e4228f01ed99030c89e2f14ff4c9b265e074c2ed708d63b36264fd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e633062bb92279fa53bba10b694dad56ecd16449811dd04b0805fcb2a1c93287"
    sha256 cellar: :any_skip_relocation, ventura:       "e633062bb92279fa53bba10b694dad56ecd16449811dd04b0805fcb2a1c93287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f7daa7df065f2f5c7585006707f8a8c1617fbb27179b7fdf570120c2a64ecb"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.combitrise-iobitriseversion.VERSION=#{version}
      -X github.combitrise-iobitriseversion.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath"bitrise.yml").write <<~YAML
      format_version: 1.3.1
      default_step_lib_source: https:github.combitrise-iobitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    YAML

    system bin"bitrise", "setup"
    system bin"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath"brew.test.file").read.chomp
  end
end
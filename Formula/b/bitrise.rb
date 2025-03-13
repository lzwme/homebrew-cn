class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstagsv2.30.4.tar.gz"
  sha256 "1f6cd79458585d28f4458473dfa1c1aad73f5ac8d31b4946e8d89308ada2c3e6"
  license "MIT"
  head "https:github.combitrise-iobitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34bc4223cb930796f2660b3eac8dfd0d1b52c0e672f6ec681ac7272b9ff8a947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34bc4223cb930796f2660b3eac8dfd0d1b52c0e672f6ec681ac7272b9ff8a947"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34bc4223cb930796f2660b3eac8dfd0d1b52c0e672f6ec681ac7272b9ff8a947"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8ed3228dffdf093e1dbef5866b4029584955d510b826d61a3fb0e98066ea8ad"
    sha256 cellar: :any_skip_relocation, ventura:       "d8ed3228dffdf093e1dbef5866b4029584955d510b826d61a3fb0e98066ea8ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4165624ac319b6c0edd0bd400c4a337589335c64910f80737675dda1c4458ac"
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
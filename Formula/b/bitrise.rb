class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstagsv2.30.5.tar.gz"
  sha256 "56022d48981ff5b18e50b57bcf6f95c57b3e6d4987805194b6c32088a09589e5"
  license "MIT"
  head "https:github.combitrise-iobitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58f08e60d460640780fa06fa67cae4624dc86fc09867f57c1454a3621237fb6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58f08e60d460640780fa06fa67cae4624dc86fc09867f57c1454a3621237fb6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58f08e60d460640780fa06fa67cae4624dc86fc09867f57c1454a3621237fb6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9379288e16c5b18454d1af6c6551e4353ed08e9ae275e2c4a66fd2f523f6d407"
    sha256 cellar: :any_skip_relocation, ventura:       "9379288e16c5b18454d1af6c6551e4353ed08e9ae275e2c4a66fd2f523f6d407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eb97176c9c56084eb5c16987d6ba3cd0d656ad483b327ff2980bad4a968b13b"
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
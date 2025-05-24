class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstagsv2.31.2.tar.gz"
  sha256 "4896a2f86f84f2a86e7461b5c62939a126a48c7e4431abedf4eace4b48e4da85"
  license "MIT"
  head "https:github.combitrise-iobitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d43ebc17f28d5a377bc5663f2182157042ad27c42dfcd3d1e79e2d2305bcb157"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d43ebc17f28d5a377bc5663f2182157042ad27c42dfcd3d1e79e2d2305bcb157"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d43ebc17f28d5a377bc5663f2182157042ad27c42dfcd3d1e79e2d2305bcb157"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd269295cff78a571ed1ba3730ed298c0cec9ddace8b5197240a118316197473"
    sha256 cellar: :any_skip_relocation, ventura:       "bd269295cff78a571ed1ba3730ed298c0cec9ddace8b5197240a118316197473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a54bc9721804e555620383af7555b285e8f2ec42d2b1d021791f26286133ba04"
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
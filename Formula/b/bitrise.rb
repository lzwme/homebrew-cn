class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.27.0.tar.gz"
  sha256 "2dd64874e60208602b5b78c4bd521926dc476766965cb46d5dc0fbd00ecd0ce9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "166c8dc722a6a385256f923d059dc19ac417c6e14de72cde3b0e65ea7757060f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "166c8dc722a6a385256f923d059dc19ac417c6e14de72cde3b0e65ea7757060f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "166c8dc722a6a385256f923d059dc19ac417c6e14de72cde3b0e65ea7757060f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3d2c7a0cfa70ce4861972519025c1b7f157c9cccaf3e561a46a4c8e34eb1d56"
    sha256 cellar: :any_skip_relocation, ventura:       "f3d2c7a0cfa70ce4861972519025c1b7f157c9cccaf3e561a46a4c8e34eb1d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a02ea4626d1afea40e3363bc87432a301126235079da383be56010d4fa684bd5"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.combitrise-iobitriseversion.VERSION=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
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
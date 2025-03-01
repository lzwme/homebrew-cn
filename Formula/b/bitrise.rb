class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstagsv2.30.0.tar.gz"
  sha256 "05ab42fcc1a22c2beb28d4deac02461df6cb5111a048915c318c8b39d064b0a9"
  license "MIT"
  head "https:github.combitrise-iobitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed6651945c5c68c3543646a5e6a1ada909b333f8d7f3aac76df1d930cc6b552b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed6651945c5c68c3543646a5e6a1ada909b333f8d7f3aac76df1d930cc6b552b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed6651945c5c68c3543646a5e6a1ada909b333f8d7f3aac76df1d930cc6b552b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d9d311898e982e2264115465441d9b86d83dc53968072ab7321cb0e1b9f9772"
    sha256 cellar: :any_skip_relocation, ventura:       "3d9d311898e982e2264115465441d9b86d83dc53968072ab7321cb0e1b9f9772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79f31b2dc6d32312a0dea1599d2a33b9da96319686c918961d7235268c429599"
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
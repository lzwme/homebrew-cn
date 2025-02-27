class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstagsv2.29.4.tar.gz"
  sha256 "1c10de9f83a5e5cabdef93c8a2c8e3715aff556def5d0fea985809e2bc5afcb6"
  license "MIT"
  head "https:github.combitrise-iobitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53592b46b5900c88a97637623ea3dd97afe10456c1401251a3cb29125a4f693a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53592b46b5900c88a97637623ea3dd97afe10456c1401251a3cb29125a4f693a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53592b46b5900c88a97637623ea3dd97afe10456c1401251a3cb29125a4f693a"
    sha256 cellar: :any_skip_relocation, sonoma:        "673188a8b5f93abae475300e9eadb36ca46020d2903ae2c44bac65cfa636078c"
    sha256 cellar: :any_skip_relocation, ventura:       "673188a8b5f93abae475300e9eadb36ca46020d2903ae2c44bac65cfa636078c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b74e9493f745deb0e2942fdd70226ea6afb96bfa9ed1037a0440b52949825009"
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
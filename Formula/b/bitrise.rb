class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.21.0.tar.gz"
  sha256 "f00ee9116d8063809abc882c8e1dea706747dc6ec92b15337cfe5d304849f407"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50ee4e919b41cc98bf799e20038c8d7cbb1ed328c439c792d97ef0d62d04f70a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50ee4e919b41cc98bf799e20038c8d7cbb1ed328c439c792d97ef0d62d04f70a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50ee4e919b41cc98bf799e20038c8d7cbb1ed328c439c792d97ef0d62d04f70a"
    sha256 cellar: :any_skip_relocation, sonoma:        "320bafc14fb839e7d01f7727bd501024f2b17fdd244167c40083d6c1aeac7510"
    sha256 cellar: :any_skip_relocation, ventura:       "320bafc14fb839e7d01f7727bd501024f2b17fdd244167c40083d6c1aeac7510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cfec57d79009916e34234c733e2eec872d1c5117a006e3d40532e7e22740a5a"
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
    (testpath"bitrise.yml").write <<~EOS
      format_version: 1.3.1
      default_step_lib_source: https:github.combitrise-iobitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system bin"bitrise", "setup"
    system bin"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath"brew.test.file").read.chomp
  end
end
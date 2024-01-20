class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.9.1.tar.gz"
  sha256 "71058b36c217c7175da21f220bbd69561e303c236e09eb160bb2faf209d5e3af"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4bb87cecc14dc04f7b234c3a7fce8781d6c3803597ba85a87f2e549d3d7ee21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bad4b4fc1aa3edb7709eafd0e8eeff06e8470a26c8e5c402a163f69151ca8ba8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c7a9e2c89f1fdcf8863e9b12af8f73ffea7a5e4255d87bc5ddd583e8341e244"
    sha256 cellar: :any_skip_relocation, sonoma:         "d078da027909f67a3fdfddbd3988d1ad7ca0bd6ad51b05dcc10cb01f35c557d6"
    sha256 cellar: :any_skip_relocation, ventura:        "d4c3074aee7d02885133df84844bcd554f3951cf5f1690adf71ade4aa5283c17"
    sha256 cellar: :any_skip_relocation, monterey:       "30cc89dde1b0864a3c086216edd0693b11ca353262514bcb794e60b47cfaa431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "128135547e7c38ea900c0df1fa1c58a4174ebf14fcd0c72769cd2d9e47b6cc45"
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

    system "#{bin}bitrise", "setup"
    system "#{bin}bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath"brew.test.file").read.chomp
  end
end
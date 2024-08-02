class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.19.0.tar.gz"
  sha256 "3725ed058bd9e4d8968538db8043d5abfccbdc356dda03af12ed32c66ccc8f99"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffdcb203ea10eb99b816b23c4950fd51e4319e88613302f13d639aa288efd514"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3906b26a8655419748b33526ed905da5aeec256696b718d67971ab1cf84c7ede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bd51c0c53873caf9c74f9ff0152a2762899378f1fffc479b4d8ca9bc9536b7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e0f97700bbfda7acf3599f565ca90c884d27a49bb66c63135eec810f61ac075"
    sha256 cellar: :any_skip_relocation, ventura:        "7a728370b4a9a23edfed90109a929388d01523242f0894ced30892528be163c6"
    sha256 cellar: :any_skip_relocation, monterey:       "6ffdeb47c05beaf362d730343cba99fe3ab608b5b7c74b5271462ca9a8ecff48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84e829d85cdce4710d86e4f9f067becf0073852536f7a9aac26c2294c29bbf2f"
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
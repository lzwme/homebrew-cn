class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.17.0.tar.gz"
  sha256 "2bcf804a6aaa8d361098c26d9c8b3e2675a183069a485c02957f428bd77ccce4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc8af0f43913462b40d94fbc677c50b46e28ae0d2a3ce5794fb099d90198abf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcaef16460bee6f67cebc76b7a49865d5bffa14135a18f9965df15be9260e5d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f13ae4e8ebda4a1e651f18d5dd1232cbaad854eaa7e0d2a4a9317b12a793e085"
    sha256 cellar: :any_skip_relocation, sonoma:         "c64f401625ea46abf185c0382ecb3739a536ac2380bdb41efceb4f50c223d652"
    sha256 cellar: :any_skip_relocation, ventura:        "29f0caa5cc5855a2c60f67312bd9e8663e4097e769095da439941ef7c99b9f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "60a5f93eea9e139859f35fbb5f31209bd4498015fb9f79fe7404d339dd295278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2e896ce13a9faf881bb0ae7ce48e0cbe123a6d99a4534a7e68fb860073e6008"
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
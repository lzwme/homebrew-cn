class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghproxy.com/https://github.com/bitrise-io/bitrise/archive/2.3.1.tar.gz"
  sha256 "dd2e1f4a85e8e73ef96841655271ce1b578eadbeb5b5bc47ae0c7bdfa0bb95d0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cc640351a2c89840a513b3f43214b5807df786e537373ac063e4fc3afda400d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cc640351a2c89840a513b3f43214b5807df786e537373ac063e4fc3afda400d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cc640351a2c89840a513b3f43214b5807df786e537373ac063e4fc3afda400d"
    sha256 cellar: :any_skip_relocation, ventura:        "f962b53988d424477285a23b5260e2bae84993810907ac3bf2c6a05db2b53f85"
    sha256 cellar: :any_skip_relocation, monterey:       "f962b53988d424477285a23b5260e2bae84993810907ac3bf2c6a05db2b53f85"
    sha256 cellar: :any_skip_relocation, big_sur:        "f962b53988d424477285a23b5260e2bae84993810907ac3bf2c6a05db2b53f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b80f8e3a8461a4ff71744ec40871551be5fb68b757f6ff8f9abf96b412a26192"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    (testpath/"bitrise.yml").write <<~EOS
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system "#{bin}/bitrise", "setup"
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
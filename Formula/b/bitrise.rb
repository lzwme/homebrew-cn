class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.7.0.tar.gz"
  sha256 "0176b0dfbf3f947150a2ad99886685dd42d9092f17521e29e884a47b52c09473"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4dbf25cd5411fe0a7483dd95ea48b4c8371862efb57b030423d455d58a78da01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b7dd58812ecd107bec2702c873b00cc200482ac5414364f66b3b8d9a49b2422"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aaeea38df3e2cc289f7d87789fbbf66e6f89a32b1a0805da7a2e0346870a405"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b7dd32ad99d51355f62b7854cbb79fb96eaf9a45511842c636b78a74c756002"
    sha256 cellar: :any_skip_relocation, ventura:        "43a1719398cce827967b365082b038ad520da115c13212e71ecc12cf0d10dfbd"
    sha256 cellar: :any_skip_relocation, monterey:       "51b4111f0567f1441fc6b4eed42ee44af5075f54a110539fb10881c0e33336dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "165598d7c320cab2bbbce3b9c149c46a897ad1bc275a81fb706cc95ed9d7b0fd"
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
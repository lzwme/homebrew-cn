class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.13.0.tar.gz"
  sha256 "3f9f13b7d37c5375d2960ae44101bd0d7f3fa6b88290b9b361e61100e6f4c76d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c3b1e3a6c911560770affb0f6053e764cf8b81951342f86d4fba23a053bd25c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbbe28a4744ec27bc73e1ed374941b91fd7cc7dcc4ebe58cc81e435a0d4402b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "322649cd1554d6012caa7b9adb2f44e2ebb98cba6acb530cb8a6007e99242b89"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd078814c6c88ad8bb464044cda81ff94405d2d42124685d83bffc2d42fc201a"
    sha256 cellar: :any_skip_relocation, ventura:        "5bb8dc109ec9613704a9db1b1c9b716d89759d84c6575eaa533568df448029df"
    sha256 cellar: :any_skip_relocation, monterey:       "3f283859ea94c2d837000e86ccf766e374f3eaba9387d6d9a949e2a50d7c9ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7800c444feecea9204755f73a5e63cb72bb7be08a12b0ab12f97764ee98f607f"
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
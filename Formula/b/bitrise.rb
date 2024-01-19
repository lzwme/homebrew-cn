class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.9.0.tar.gz"
  sha256 "8436d396dc6ed2706cc8b313580ad2eab63a4b379e8409f96f0b33e39c96bd36"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5087486918806a026110a33f73c53b16790623f37bac87cb62b960f7414b6830"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2de01ff8e3d53992af6efe9b533b301f54e6c30f899feeef93c622b84cb3be84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "906fed474990da98a4f10e76d2fbf687da999a3e6adb3ca67411cfd5c2154ba7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9a45b9593780ab8f795f8fc6a9d06330722087af145bf79d0af1c71ecd61c2c"
    sha256 cellar: :any_skip_relocation, ventura:        "ca3f78aead9f36a20115749ab53cde97051c3088be55355caa90a4d9168d27c9"
    sha256 cellar: :any_skip_relocation, monterey:       "7e65fd1882c78e50774c12be4495c752d820cf64a38b744c17d923acc3d1d5cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05f6767ea14b52e4f99c0991e63270760772143441d3c10ef05151641c576885"
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
class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.20.1.tar.gz"
  sha256 "84eb81b09d247e6a70b7239079d6206343d7679ee058f310c64b64ceeb1036eb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "597acdd15f161f3ccaaf6121ad5db4cce009712ab800a88b7b1e529013adefbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "597acdd15f161f3ccaaf6121ad5db4cce009712ab800a88b7b1e529013adefbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "597acdd15f161f3ccaaf6121ad5db4cce009712ab800a88b7b1e529013adefbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9236aa198dbbf41f8ebad82997ed92086fffe16f3dca9fa70dae87478b6ff2c"
    sha256 cellar: :any_skip_relocation, ventura:        "d9236aa198dbbf41f8ebad82997ed92086fffe16f3dca9fa70dae87478b6ff2c"
    sha256 cellar: :any_skip_relocation, monterey:       "d9236aa198dbbf41f8ebad82997ed92086fffe16f3dca9fa70dae87478b6ff2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da3ad2278ce661f7138b4935abb9e136b2762f91ca2f71aeed79f5327cd54055"
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
class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.14.1.tar.gz"
  sha256 "f13429bdc5bba604e89ac8b675d5a82155936df158b5cd3c4b33d9b46510fd91"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "045048344effabefdbaf2e0002153375388c6f73b5bfd3d3fe0dcc46e4d10b84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0048f9d0d47d5f99fc34508f5720c3708b1916ff71b8801b2dcd6f6e108d9e60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee65dfe9f6a56c591d9a6cfd9dd6b6063839f7af57e2c125b7f3bdc95e46bbb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f262847c68ba47576126faa66209cc80093d4db1a442ac17ba9e2878cc4cab8"
    sha256 cellar: :any_skip_relocation, ventura:        "13d675ad4f6cc35ce5a09f29df4c7875189e9e4d0daad5ecfb9415ebe787cc2f"
    sha256 cellar: :any_skip_relocation, monterey:       "b353c924b1a3e6b1a6b69a48efe4f496eece02bcb8525b27b84608e5ccb280ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "020a8f6ce2a859e4a69d424aa9b092a0561b215773ebd167b11fd50745f33fd9"
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
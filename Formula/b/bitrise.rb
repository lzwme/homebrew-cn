class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.29.1.tar.gz"
  sha256 "3b2fa95ad6e6c09c7e83f2746b01b03cffc9f8c389fa1f8aa7e4668ff9fded10"
  license "MIT"
  head "https:github.combitrise-iobitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c810adbcfafd3d36f8afb67521cd5266ed2c32f3781cf3adafd96462d0c2074d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c810adbcfafd3d36f8afb67521cd5266ed2c32f3781cf3adafd96462d0c2074d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c810adbcfafd3d36f8afb67521cd5266ed2c32f3781cf3adafd96462d0c2074d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b37902b180ec575d231748934d924ab5be6db12280d9a2d9d6ba9bfbee4ff93"
    sha256 cellar: :any_skip_relocation, ventura:       "7b37902b180ec575d231748934d924ab5be6db12280d9a2d9d6ba9bfbee4ff93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "486b054726539f7795e4c1765f53276807abc463d8005729661031306cb9c6a1"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.combitrise-iobitriseversion.VERSION=#{version}
      -X github.combitrise-iobitriseversion.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath"bitrise.yml").write <<~YAML
      format_version: 1.3.1
      default_step_lib_source: https:github.combitrise-iobitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    YAML

    system bin"bitrise", "setup"
    system bin"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath"brew.test.file").read.chomp
  end
end
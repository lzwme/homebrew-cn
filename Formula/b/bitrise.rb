class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.26.1.tar.gz"
  sha256 "315ea63190e0628cdacd779227c1846a7574066000ad8624485b20b62c5ffcea"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f76c00e544394f33ffe037d670b32bf0017c58505154cf170bf8d488bc64566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f76c00e544394f33ffe037d670b32bf0017c58505154cf170bf8d488bc64566"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f76c00e544394f33ffe037d670b32bf0017c58505154cf170bf8d488bc64566"
    sha256 cellar: :any_skip_relocation, sonoma:        "059a75c82b031fe07ab64eb29b7e63fe5172ace483c8844126b29c5554cbecd8"
    sha256 cellar: :any_skip_relocation, ventura:       "059a75c82b031fe07ab64eb29b7e63fe5172ace483c8844126b29c5554cbecd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ae5f764eb046c59dc708bc4baa73a082919a1ab9e47121c05363161de2a531"
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
class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.26.0.tar.gz"
  sha256 "3b46e8b136f65817ee85ccaa0a40f7909177738162dacc9be7b4d575b5b53e00"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "583a03293e5bf059de77dd1685d27a107cd0cbeb3cca2e2560a2a2f78ce28667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "583a03293e5bf059de77dd1685d27a107cd0cbeb3cca2e2560a2a2f78ce28667"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "583a03293e5bf059de77dd1685d27a107cd0cbeb3cca2e2560a2a2f78ce28667"
    sha256 cellar: :any_skip_relocation, sonoma:        "c79da3ead37a3da29b1775badf5d419fa69a123211ca8a45a1908c6d2e0b38e9"
    sha256 cellar: :any_skip_relocation, ventura:       "c79da3ead37a3da29b1775badf5d419fa69a123211ca8a45a1908c6d2e0b38e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bac54e08bbade2d4444ba747ff8226c708af063cf35324457936ca325674c4d"
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
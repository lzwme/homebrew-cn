class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.23.0.tar.gz"
  sha256 "cd8654156b19c040f66f2a62e9cdd626c13ea816968f1bad3d8aea880f60bec9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d81df9e9de13ec5154872091d73371dac2393954816d81eb783f107a16aeb9b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d81df9e9de13ec5154872091d73371dac2393954816d81eb783f107a16aeb9b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d81df9e9de13ec5154872091d73371dac2393954816d81eb783f107a16aeb9b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "768196b5534dc13be9b08271a2d8600f488083af08b00f43669fd07b4093ef6a"
    sha256 cellar: :any_skip_relocation, ventura:       "768196b5534dc13be9b08271a2d8600f488083af08b00f43669fd07b4093ef6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45dbe0baf537619cb3e57cadc80613f07b0c6fe9d5d627cde6eeb6600fee058a"
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
class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.25.0.tar.gz"
  sha256 "621213c423724b9c33a36fdbdc5f5d956ebde43c27d38fd6f0f693a4022be42b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e516ebc63fdfa3832838820c31fafe7f61b7d860e7e65177b12492e23c0286c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e516ebc63fdfa3832838820c31fafe7f61b7d860e7e65177b12492e23c0286c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e516ebc63fdfa3832838820c31fafe7f61b7d860e7e65177b12492e23c0286c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "dff5436ef44a15f6b0c05839ddc42e6b18bd82aa9e576910c62dba84c745466b"
    sha256 cellar: :any_skip_relocation, ventura:       "dff5436ef44a15f6b0c05839ddc42e6b18bd82aa9e576910c62dba84c745466b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abb3b2618854f928e330e888d46c02cf19a25f4cf8fac240754f3cc932bf7a3b"
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
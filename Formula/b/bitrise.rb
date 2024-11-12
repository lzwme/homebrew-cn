class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.24.2.tar.gz"
  sha256 "fbdcf55d19ff90960ed90c097ad3a9949950ab123d63924d67555100b2208985"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c174de57802525de1789b0b84e7f44c2286bf2f935c79289cc2a82a0b509e0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c174de57802525de1789b0b84e7f44c2286bf2f935c79289cc2a82a0b509e0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c174de57802525de1789b0b84e7f44c2286bf2f935c79289cc2a82a0b509e0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "562d803b1597d9b1f0a76be4d1d1682fed98f64ac4f086fbfb1a53b5822e1d5c"
    sha256 cellar: :any_skip_relocation, ventura:       "562d803b1597d9b1f0a76be4d1d1682fed98f64ac4f086fbfb1a53b5822e1d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c636157fbb0e48409ff1b483e5ed18328556ed941f4a06081451a1f6106803c6"
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
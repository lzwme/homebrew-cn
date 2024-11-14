class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.24.3.tar.gz"
  sha256 "d8e434a35ae73976ec5cf5578872abe677edbe245eb056b991c36d75ae5fe5fd"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36dea81cc24fdfd5a4305324af6381c75b5fc6a4e7e2bf6d4d559552ffd800b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36dea81cc24fdfd5a4305324af6381c75b5fc6a4e7e2bf6d4d559552ffd800b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36dea81cc24fdfd5a4305324af6381c75b5fc6a4e7e2bf6d4d559552ffd800b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a204c346b2a580c00d6577747f6d43fdfe87305e723f98def1ba68acb40ec673"
    sha256 cellar: :any_skip_relocation, ventura:       "a204c346b2a580c00d6577747f6d43fdfe87305e723f98def1ba68acb40ec673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19bf65765dbfb86a469d4a86376c05d4b433a1d98f56b5059e124f798f0eb601"
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
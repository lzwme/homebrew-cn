class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "b413306b475a5a787a67f50572a2ce5cd7f57a8214b77a4b5f20b751706b74ad"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "430bdda141bc8e2dcdac2bf72769fd5fd60fd85fb37d40bcc9aff4212f880217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "430bdda141bc8e2dcdac2bf72769fd5fd60fd85fb37d40bcc9aff4212f880217"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "430bdda141bc8e2dcdac2bf72769fd5fd60fd85fb37d40bcc9aff4212f880217"
    sha256 cellar: :any_skip_relocation, sonoma:        "6436186d43c990e2fcd8360b627e19682c0ac3784e641d77cca484cf3b8bfbed"
    sha256 cellar: :any_skip_relocation, ventura:       "6436186d43c990e2fcd8360b627e19682c0ac3784e641d77cca484cf3b8bfbed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57b0ba7181a1d2e364a4358120fe000433869fea5f203621de48ccbad3377ec7"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"bitrise.yml").write <<~YAML
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    YAML

    system bin/"bitrise", "setup"
    system bin/"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
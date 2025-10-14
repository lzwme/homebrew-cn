class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.34.3.tar.gz"
  sha256 "23f116397cc354eaba8c1b7fda4eb6d1720dd5f9679e8bdf2a3b5254a60d0542"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57e241d1fff5ea5e4683ff5ac6e392496cb4edac1541713a1af80b7162f68d4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57e241d1fff5ea5e4683ff5ac6e392496cb4edac1541713a1af80b7162f68d4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57e241d1fff5ea5e4683ff5ac6e392496cb4edac1541713a1af80b7162f68d4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4687bba2d77e9a8f23f6bbdb4a169a3257756e1b8879be269a1492a146ff52e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92ef67f546a0f0e497427acec01ff8d25056f43f6fd094842bcd1b5c21abf0ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c343fce7a9ac902aa6ebd6fcba672bc4b9de6e743f66cec1ababa94a5df8cfaf"
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
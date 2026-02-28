class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.39.1.tar.gz"
  sha256 "1ddd2b2aad1335f73f7c7128b619ab3911e08ca40a9ab62395f48961e61aeafc"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50046d845364a527c2d49bbf2166688ebb09c54557371b94c2354962ee27de39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50046d845364a527c2d49bbf2166688ebb09c54557371b94c2354962ee27de39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50046d845364a527c2d49bbf2166688ebb09c54557371b94c2354962ee27de39"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe1bf6507ef22614133e5bf83354a3befa1242a44641b2f2b0e69706bfcc493d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b71e40fcd67ac0bbe1e5bd74bff503c96e10d28d170b2ce5f5d266217a6d089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b05206c334b6a2d7ec20d3af2224ecb0114941826963d0d15c935d66471e6110"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
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
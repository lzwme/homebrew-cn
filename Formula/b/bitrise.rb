class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.40.2.tar.gz"
  sha256 "aa1e53dead9f060d85132b861684717d7f67d4675f5a55984d6a66277505a08b"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48f12970750542e3646ea11635b56363deb8fa0244d6f594546d09a20542d855"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48f12970750542e3646ea11635b56363deb8fa0244d6f594546d09a20542d855"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48f12970750542e3646ea11635b56363deb8fa0244d6f594546d09a20542d855"
    sha256 cellar: :any_skip_relocation, sonoma:        "35329f156551596fce6fffe6e0bcac4d324b2d09cc95180fe4c700637be51158"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5c9ea028fdf728e2ffcb4b572e742449f63b0098556b293bce0b8ab6622bc77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60a243143b78e53be1f0129f2d59e0d3714a7909092f725a108c9dbc15bf4ebf"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bitrise --version")

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
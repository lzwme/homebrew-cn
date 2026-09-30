class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "1706f3d54b5e963c11a75108adee6e077041e02d8503b3c2ffab06e5267ca1c6"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d957e2059647bcbd6251d73a80ab765ccc4c90ed64d1eaed8ea6e35bdf3a750b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d957e2059647bcbd6251d73a80ab765ccc4c90ed64d1eaed8ea6e35bdf3a750b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d957e2059647bcbd6251d73a80ab765ccc4c90ed64d1eaed8ea6e35bdf3a750b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2a12e9df879e207ab6b211154fb87280ead8c51a01a5ba1f1ce03f1785abf747"
    sha256 cellar: :any,                 x86_64_linux:      "e6f87a3177d59fe33ee9191da9dc57cb68057faa08d72468b00d64ffb2f8fc6a"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  # Test downloads the envman and stepman tools and the step library
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
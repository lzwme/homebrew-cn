class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.41.1.tar.gz"
  sha256 "c044deeb4756b92e12fcd18831f84ae74d0b13c92209910c455f16674f0729c2"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "885ba13eb66225c91636b5647d5508f4f8b4a34a78c4d5d1efda4874afa39459"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "885ba13eb66225c91636b5647d5508f4f8b4a34a78c4d5d1efda4874afa39459"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "885ba13eb66225c91636b5647d5508f4f8b4a34a78c4d5d1efda4874afa39459"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aa4144ce6be87c75f09759f354ef5edd17be529adc4cd1e31a2ad2cc6f4619d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15e944fb769d6d01d10e4cdf08e483ad867cb2e378d54be9d0d768ec8bef50e2"
    sha256 cellar: :any,                 x86_64_linux:  "5385318405ff6458c8eb21fc171e043b81b1654aec1c201325f551ed912fc851"
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
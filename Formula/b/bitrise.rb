class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.40.8.tar.gz"
  sha256 "3883ee7b8b086af69872a1fd52278494c7bf1f46aa303a1e3e9689b0727390ca"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d676076683d5d210cbf6cc58f6bf2667d8a71d2a8070cad6d5cfd835699651f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d676076683d5d210cbf6cc58f6bf2667d8a71d2a8070cad6d5cfd835699651f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d676076683d5d210cbf6cc58f6bf2667d8a71d2a8070cad6d5cfd835699651f"
    sha256 cellar: :any_skip_relocation, sonoma:        "72a6dfc2a281ebb42677c3f5a89d3759d773804d8e506390fbdcef79239cc2ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa843ba69ffa34eb1dd5d2d06b42cbabebc4b07888a440f5a44a927c6637f7cc"
    sha256 cellar: :any,                 x86_64_linux:  "f7ab43e0454cd3c586d43f87fbd96e67b0e55bbc623192ee421c81224061ac96"
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
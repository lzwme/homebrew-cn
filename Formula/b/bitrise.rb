class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.40.1.tar.gz"
  sha256 "8a896983061d8b458d25fa30b84b51a71f45789b3f39476d726a805a995c6e58"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0e2740ca09b1c107e0ece499cde30aefb35d7ddee3f6fb9d4a37208a72ffd5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0e2740ca09b1c107e0ece499cde30aefb35d7ddee3f6fb9d4a37208a72ffd5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0e2740ca09b1c107e0ece499cde30aefb35d7ddee3f6fb9d4a37208a72ffd5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "862e0b35d64de3111844d18295ce5114eb2a2a6b1b1f0b6bff0bb4ad64256401"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a60f5a100a2038ade3513698c0cddb160125b5e3c3b1ba325932dd0bc6f41b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8331857b97e123238b3f688a0956bd6756d9a3952c46ea41acc41d38bf563a3d"
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
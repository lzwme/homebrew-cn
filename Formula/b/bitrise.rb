class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.43.2.tar.gz"
  sha256 "21892b75bc6cba376e898fe66be88bd429602a9ec8355c3af44f7b70c2455b39"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bf3a465dfdd972580213b7f6ef8cb9ad5555cd872ae2651a0b08e90fb993b1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bf3a465dfdd972580213b7f6ef8cb9ad5555cd872ae2651a0b08e90fb993b1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bf3a465dfdd972580213b7f6ef8cb9ad5555cd872ae2651a0b08e90fb993b1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3739517b7cd341dadcb28d84951f322451dab818954eafb5daccfbbdb787a17f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1e075e21792df6cd348cd8e11e5a8375dcba23753464f1ca6a30bf0debe6ed9"
    sha256 cellar: :any,                 x86_64_linux:  "d1a6ac8a8ddf564d9f18eeee145e8da1f275c0c6d189c1902fb275f11a9fccc5"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

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
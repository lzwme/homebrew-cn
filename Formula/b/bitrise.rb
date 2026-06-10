class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.40.5.tar.gz"
  sha256 "6afa60bf714f2134a3d2e366955c6ce3af3c675fb2ee47351d95cee064a4e729"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "048725d7b142801034bcc9ddc74d986c86db767c7958396bb18b81c9f61bafcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "048725d7b142801034bcc9ddc74d986c86db767c7958396bb18b81c9f61bafcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "048725d7b142801034bcc9ddc74d986c86db767c7958396bb18b81c9f61bafcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "14d13cd7f5e2f105f9b2c74d7dc3cec3857689a57fb5697c0cd4ff2d78318558"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80d147901bc0a722d5ecd353386827e76e69eb9f05e3e90126dbdc900e3ea049"
    sha256 cellar: :any,                 x86_64_linux:  "559da0876c182028cc4d8f4af549ef340026bb1263783b7fb77084f0e167d8e0"
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
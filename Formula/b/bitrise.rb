class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.40.3.tar.gz"
  sha256 "aba052462915b1a8720f8903cf71e721bcaf9adcdf027821646c91b6fbb7c983"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecca13b3e2cba7cd0f91aa68ba7c6ec2d581bd0d29eaac992d2120b308f57c2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecca13b3e2cba7cd0f91aa68ba7c6ec2d581bd0d29eaac992d2120b308f57c2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecca13b3e2cba7cd0f91aa68ba7c6ec2d581bd0d29eaac992d2120b308f57c2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1dc5d2ef7203fcc9ae463ca47e34291be3750de8fad828de8a071f9e0ed193f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e29c16eaaceed9919f9ba7658da620f7efb8162103cb82adf160e46c46df331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "088a9a7219649aabc774f941d7c76a5e5df218e2bb700f1b77a6ec46c7aaa23b"
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
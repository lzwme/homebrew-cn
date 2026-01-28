class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "bfbc47097bdffe83b7b1c8e2aaaa0f8bc7221edcfa81041e5563806b4a489608"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10ea2280c99e77cd4f3ede2b82624ec073f51d26333ffab54f960a0e1192d511"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10ea2280c99e77cd4f3ede2b82624ec073f51d26333ffab54f960a0e1192d511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10ea2280c99e77cd4f3ede2b82624ec073f51d26333ffab54f960a0e1192d511"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae85dc8e80161a6a575280762584d63f28101f5572f3b9df29c885afad2aa25a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "847f187e7bb41720f799cf7a436d722b76a342dae5909ff77d3eabc75aee4362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86036b2870a8c0a4cfe1f9cef947fce890b11b10c5034122601fcb90d59d4382"
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
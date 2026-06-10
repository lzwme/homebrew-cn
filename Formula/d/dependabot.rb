class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.88.0.tar.gz"
  sha256 "38cd3054e4fb49387d3bf0f395f4889587e50d22e5769f2ce1db7bddba82b023"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2274c3e3f3d873dc3316be58609cf8216b2253fbc5e0001929cc678165dba97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2274c3e3f3d873dc3316be58609cf8216b2253fbc5e0001929cc678165dba97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2274c3e3f3d873dc3316be58609cf8216b2253fbc5e0001929cc678165dba97"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca6d8a37fa9707ea8b48a36adb305d9e948dadc44edf1a8b206a0354c9cb5f53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf84acfcaf93377b97295d2c868d012396fab0418c3fd1536019d7cfa008ea06"
    sha256 cellar: :any,                 x86_64_linux:  "7edeba414cddd245075b061e18487deb1a68a05c6a3d80d521c7b10c5903dc10"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end
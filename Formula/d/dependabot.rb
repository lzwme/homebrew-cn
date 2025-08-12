class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.70.0.tar.gz"
  sha256 "9220441599d56d4ea57e2d925bfe6513ab13ad692f359031b2abbfb4096b9007"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9712725231bc58a030bd5ce88f27f286bde0d9e311c256c2c598f66c8bdff07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9712725231bc58a030bd5ce88f27f286bde0d9e311c256c2c598f66c8bdff07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9712725231bc58a030bd5ce88f27f286bde0d9e311c256c2c598f66c8bdff07"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5403cd03717aa0849e98d7328f64a8320f35d47b20113783e0488b1ed68b46d"
    sha256 cellar: :any_skip_relocation, ventura:       "e5403cd03717aa0849e98d7328f64a8320f35d47b20113783e0488b1ed68b46d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d93c34ed1a1b59fd8fc908253edc36915ffccbcef09f210954a63da50f317504"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end
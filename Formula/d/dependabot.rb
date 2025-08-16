class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "cc37e707b8e8a84ac51feca35c8acdf18189b5105b979dd1121b04a984128759"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afce9999d4aa6240c526330ab7a6cad8f3fc6dbc9fad3a3b58dd1443558f02d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afce9999d4aa6240c526330ab7a6cad8f3fc6dbc9fad3a3b58dd1443558f02d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afce9999d4aa6240c526330ab7a6cad8f3fc6dbc9fad3a3b58dd1443558f02d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fece486f99b6c071cd1a85da03ed5c95b5d2dd141ceda5dc91fe65c8a245c14"
    sha256 cellar: :any_skip_relocation, ventura:       "1fece486f99b6c071cd1a85da03ed5c95b5d2dd141ceda5dc91fe65c8a245c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "390ddf32126ee91c5c7a0c6ca65ff19240f964e9b52f98831f02925cf26e21be"
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
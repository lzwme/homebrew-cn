class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.76.1.tar.gz"
  sha256 "c70594e324d89f52e549c7fd419c7a717322eeafc4216c3819ee16e13b499d15"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4388f41a065b5ad1d895ec0a2f189fdde7a29ec9afa841bb0a84926cceabb1a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4388f41a065b5ad1d895ec0a2f189fdde7a29ec9afa841bb0a84926cceabb1a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4388f41a065b5ad1d895ec0a2f189fdde7a29ec9afa841bb0a84926cceabb1a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b220a4d986b9eaaa69b7b5f061898fb83fade3408eb3dfce4d99fb15dde7a46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da4689b134f4275404e0bcb6c75e401a7fea55a0a47079f3827794a56f85c15f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "691f02d8444492bd7e37320945ed5fc04bbfa43bfd6d9252b744d85691877d0d"
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
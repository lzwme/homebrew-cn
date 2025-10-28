class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.77.0.tar.gz"
  sha256 "8b1d64d32d435894bd49257e7a8bfd0c614777b5f372c6b8d5f1142d9a8760ec"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3df3eab0b8418d9240c11f92fa4e2272b3d131dd53c677b8ab45de43570662d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3df3eab0b8418d9240c11f92fa4e2272b3d131dd53c677b8ab45de43570662d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3df3eab0b8418d9240c11f92fa4e2272b3d131dd53c677b8ab45de43570662d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "392c8525f6ec3a1ffe321d62d9e95aa0e3588d1775597bb30bd3d60c3faa13b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "893202e8ccc1e232326eedaed7e7f873b359342ebaf854caf73f6349a6c150b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dd3d1060f4c56060ac5bf23ed6ac003e1a5b98d7ae5a13676a51e3147f0e8a1"
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
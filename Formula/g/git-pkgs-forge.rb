class GitPkgsForge < Formula
  desc "Go library and CLI for working with git forges"
  homepage "https://github.com/git-pkgs/forge"
  url "https://ghfast.top/https://github.com/git-pkgs/forge/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "dfbe5b6ffe24d93d37f3a3aab8eddf6081eb2b44fdd37aad293201a316e1574d"
  license "MIT"
  head "https://github.com/git-pkgs/forge.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "430cf7c160735215672e98a9e88abac07c7cd04476ba7006f1b85925add48e67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "430cf7c160735215672e98a9e88abac07c7cd04476ba7006f1b85925add48e67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "430cf7c160735215672e98a9e88abac07c7cd04476ba7006f1b85925add48e67"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a1589f532f699a59b60b23c28a1ff6ae637e0dc3c5b7884439836f057ba3659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ece6c47433bf10ca61ed14d38aaa4645263fee4ff5dd7ea3dd3548c2400a85bc"
    sha256 cellar: :any,                 x86_64_linux:  "1a0a8dfb2e89586f0970e57b213000894acce5d4602b1dd9136410c4bbf7f5fb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/git-pkgs/forge/internal/cli.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"forge"), "./cmd/forge"
    generate_completions_from_executable(bin/"forge", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forge version")

    output = shell_output("#{bin}/forge repo view 2>&1", 1)
    assert_match "Error: reading remote \"origin\"", output
  end
end
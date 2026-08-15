class GitPkgsForge < Formula
  desc "Go library and CLI for working with git forges"
  homepage "https://github.com/git-pkgs/forge"
  url "https://ghfast.top/https://github.com/git-pkgs/forge/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "25faad2e6d25e4b30639272a8116f957afc38b8c1e6e97cd55410fe8b76f9055"
  license "MIT"
  head "https://github.com/git-pkgs/forge.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb75f8838db5e36983c252ae5640135312c4f1ef8c178ddf9d0dfe6fc55e1830"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb75f8838db5e36983c252ae5640135312c4f1ef8c178ddf9d0dfe6fc55e1830"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb75f8838db5e36983c252ae5640135312c4f1ef8c178ddf9d0dfe6fc55e1830"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4c810e893f96251f2abf6dd264eb0c57c1ded69b4e06d65123fae3a02ef8c3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0497553bff26fb51da8609c43cf090a4657b85ef09f628ed8d61cf32fc4342bb"
    sha256 cellar: :any,                 x86_64_linux:  "394611da86ba5e18097ed75a63922a6fa54050f8a31f3fbd32528a6dae61c753"
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
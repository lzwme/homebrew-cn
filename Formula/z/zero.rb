class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.gitlawb.com/"
  url "https://ghfast.top/https://github.com/Gitlawb/zero/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "250e6cd090ea4f8fc0c2b42267d7c0563ed54ff00080a810b907f26328f0d38d"
  license "MIT"
  head "https://github.com/Gitlawb/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4ac81658d12065320947d0f7149ef8236d96dba5fd01a253b7102948dd897872"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ac81658d12065320947d0f7149ef8236d96dba5fd01a253b7102948dd897872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ac81658d12065320947d0f7149ef8236d96dba5fd01a253b7102948dd897872"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "474e1b187ba2261d54baae682aabbee41fcae77319f3d6f8c912ab3dadfa351a"
    sha256 cellar: :any,                 x86_64_linux:      "974678a3ed90422888d1b9094666f0b97f4a3188a3c88e449666de82685ff173"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Gitlawb/zero/internal/cli.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zero"
  end

  test do
    (testpath/"cmd").mkpath
    (testpath/"cmd/main.go").write <<~GO
      package main

      func main() {}
    GO

    assert_match version.to_s, shell_output("#{bin}/zero --version")

    output = shell_output("#{bin}/zero repo-map --max-files 3 --max-depth 2")
    assert_match "Repo map", output
    assert_match "cmd/main.go", output
  end
end
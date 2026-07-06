class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.gitlawb.com/"
  url "https://ghfast.top/https://github.com/Gitlawb/zero/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "03033d8be2adebc3023bfe9a37ecb6067981d0aa0dc2978ee4d203c742a43d6e"
  license "MIT"
  head "https://github.com/Gitlawb/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd977cffd79355eee27f5c032ca5b6b145e511b687c9f6a89249f9af4aef58cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd977cffd79355eee27f5c032ca5b6b145e511b687c9f6a89249f9af4aef58cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd977cffd79355eee27f5c032ca5b6b145e511b687c9f6a89249f9af4aef58cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c12f58c2c548569204666e1e16938cc3ae85d217ee86858e7269940ea762025"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ba3f438d6c9ae4ae7e06a00373e5240b42e59a30e21813a16d216f281f6bd1a"
    sha256 cellar: :any,                 x86_64_linux:  "0d5bad4f986feeb2db4d38bf3517776f6579be7c747a1f324a6c40daa9434deb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Gitlawb/zero/internal/cli.version=#{version}
    ]
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
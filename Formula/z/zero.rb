class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.gitlawb.com/"
  url "https://ghfast.top/https://github.com/Gitlawb/zero/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "9e847706bf29af44ae868fa560b919526589b43d675b1ff9c09d8e3444f35448"
  license "MIT"
  head "https://github.com/Gitlawb/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf92d5a037c827b93ed669873a4e50bfabb717effb516e3dd17c905b7e3c550d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf92d5a037c827b93ed669873a4e50bfabb717effb516e3dd17c905b7e3c550d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf92d5a037c827b93ed669873a4e50bfabb717effb516e3dd17c905b7e3c550d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b28bcc5b7445b26555714ad3f9a3cb32e033fdc5b3d2f48d7214586f7ad23eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "620c5b61b106bbf96572a8c045deffc76a9e62873856ee431c556c438bb5bf72"
    sha256 cellar: :any,                 x86_64_linux:  "a9e69f7c263603c7e814304aa0ebe2d9ed84bc069d8e00b6dfc29eab35f2539e"
  end

  depends_on "go" => :build

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
class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.gitlawb.com/"
  url "https://ghfast.top/https://github.com/Gitlawb/zero/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "27ff6fc90634af32d24b4fddad78432da02992ea806e8e569d3f49a8a9c8cab0"
  license "MIT"
  head "https://github.com/Gitlawb/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cd952c85e272ba57e78a6ab7fec3b7f9eaf2fbc381e1c5cbb5ac9c4ac45008e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cd952c85e272ba57e78a6ab7fec3b7f9eaf2fbc381e1c5cbb5ac9c4ac45008e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cd952c85e272ba57e78a6ab7fec3b7f9eaf2fbc381e1c5cbb5ac9c4ac45008e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dca37a44bf690d70d7d925a05388c01c6332d1d96418910052ad16dbad85b8ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6084bea1d42d359c0a5e0081aba6d00e32f486c022b8f663ff9a38b02438620"
    sha256 cellar: :any,                 x86_64_linux:  "cb822054a98fe0ca7fc0efeb507d012b337ad0d088652cddb3509ff4bb3abd1a"
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
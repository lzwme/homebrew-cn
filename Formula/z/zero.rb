class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.gitlawb.com/"
  url "https://ghfast.top/https://github.com/Gitlawb/zero/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ddb686009ab5fbd73e596577fff01b03ed1699b7fd1f8e07594432403eb37ca5"
  license "MIT"
  head "https://github.com/Gitlawb/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e6506f99a087a735ac7182d53b1a80e8c9b068f04115b2b4fb7126d62e573bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e6506f99a087a735ac7182d53b1a80e8c9b068f04115b2b4fb7126d62e573bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e6506f99a087a735ac7182d53b1a80e8c9b068f04115b2b4fb7126d62e573bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea8c359b6346b76f2c8d7c79538bdfe456409f3e6660204a9a313622e009240e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55a47ef38aabefac398415c8e2b2ae03a4cd5692caa313f7188683bbc83e3a43"
    sha256 cellar: :any,                 x86_64_linux:  "948c61249a29aa2004de8cefeaf95787b12e8a1c9d5796ca9b2af40a45446d1c"
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
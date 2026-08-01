class Mcpsnoop < Formula
  desc "Transparent proxy and TUI for debugging MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://ghfast.top/https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "0b14184614b4b4cd59070607c9cba41fdb3178af0741e53d751db23256530118"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8b94b7d6cbee9c0cdf9f38175a6634addc773626ffffba656470ef43cc82308"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8b94b7d6cbee9c0cdf9f38175a6634addc773626ffffba656470ef43cc82308"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8b94b7d6cbee9c0cdf9f38175a6634addc773626ffffba656470ef43cc82308"
    sha256 cellar: :any_skip_relocation, sonoma:        "fde1bbf6d0d6218fb91ff81e7f635c75f79cfb1ee71cd7d20fecf8601e572fc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc66a35113db0bf394bf93713cbc65e9572e67906bc169ad72952987910d0ebb"
    sha256 cellar: :any,                 x86_64_linux:  "6adf2654e48c667e8a6b7295c32e130f5b6305f034f067c4bf221f0bc6166b41"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/mcpsnoop"
    generate_completions_from_executable(bin/"mcpsnoop", "completion")
  end

  test do
    ENV["MCPSNOOP_HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/mcpsnoop version")

    # Wrap a trivial "server" so the shim writes a real session, then check it.
    system bin/"mcpsnoop", "--label", "brewtest", "--", "true"
    assert_match "brewtest", shell_output("#{bin}/mcpsnoop export -T text")
  end
end
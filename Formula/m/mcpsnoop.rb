class Mcpsnoop < Formula
  desc "Transparent proxy and TUI for debugging MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://ghfast.top/https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "7f4a88fab45e7775a9a11a5c40a0f58383c89270dfa050ec02e9dc94f73d1a62"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0b7ac6ed3dc2361b2b319e50635c48ca327b5780d212d85e5697cf57154f67b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0b7ac6ed3dc2361b2b319e50635c48ca327b5780d212d85e5697cf57154f67b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0b7ac6ed3dc2361b2b319e50635c48ca327b5780d212d85e5697cf57154f67b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3142da9da0bba855c4fe099a0011be46d9b816da5f72099b2d25205941d157b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d36c37e9646ce596981d114461953da20d16f3503435b3a5cb7dc670d48d8ef"
    sha256 cellar: :any,                 x86_64_linux:  "7105089149e34bdd3245559d73562761dcf5433a3175a750fbbf8de2fe1b84d0"
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
class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://ghfast.top/https://github.com/mark3labs/mcphost/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "3484a6d95483dcf43b9c36b2bc8b4c8025fce289b4ff85c3ea4b5026aad18b85"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d7708ccb7862998ee97e115862e6ee54098720a4d6fff091034f2200de3e7bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d7708ccb7862998ee97e115862e6ee54098720a4d6fff091034f2200de3e7bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d7708ccb7862998ee97e115862e6ee54098720a4d6fff091034f2200de3e7bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e2b5f97e692f75d8641d81901e4fd158d39c991fe7a185f5b14501c5632a5f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e13dfe2a8393c5df6f8f83eaaef0144db23a4d678781fac47234db60efe40aaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d7e47fdb1fac51c7241139ed8ca9da0627fb04e45d83bc90dc58662ed28bdaa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mcphost", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcphost --version")
    assert_match "Authentication Status", shell_output("#{bin}/mcphost auth status")
    assert_match "EVENT  MATCHER  COMMAND  TIMEOUT", shell_output("#{bin}/mcphost hooks list")
  end
end
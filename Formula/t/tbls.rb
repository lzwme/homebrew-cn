class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghfast.top/https://github.com/k1LoW/tbls/archive/refs/tags/v1.94.2.tar.gz"
  sha256 "7141d9964101187ab7804e35db466c39e5f9be8a82ce5a2977251cc3417af898"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e34921b41bba3bcc6aded9e4ba193744ade860294ebe769e0962376d3879ebb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61a9636ca06a52c618c79ebc6418a457a297e85a1e9c5f167a49ebb4eef7d202"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bee0b5ea9bf1f39f07c592995362824df5e0e771a8ce27f39d8a922e2e72194"
    sha256 cellar: :any_skip_relocation, sonoma:        "5afd6408676230f68104fd21cf2c187644740755010ce0bc435ca7ace2abc70d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf3dc2ae0b992218ec428ce022c2e9bf12700de01634699ed6375530b78f5bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbc9ec3c3a39ed4ec5a59489da026523f9c791facea2f26a1edae098bcdae68f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", shell_parameter_format: :cobra)
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end
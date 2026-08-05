class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "0a05ed2b7f471a4f6916955d20b90a33bed9f1761b8399fa7d7e2ccb39796d9b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e545a56b0f230944ca22b16196c85d91de89728cb58158a31c2ecb6aec880df3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e545a56b0f230944ca22b16196c85d91de89728cb58158a31c2ecb6aec880df3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e545a56b0f230944ca22b16196c85d91de89728cb58158a31c2ecb6aec880df3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c2e79050b8d21715c08e185d533784ae7c0dc0833a2fbf71c13c0298ad0f965"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone", "sv-agentsview-setup"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone", libexec/"sv-agentsview-setup"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
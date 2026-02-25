class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.22.tar.gz"
  sha256 "b69219962e985ecb8e62c57fd6feb0049ef9a61f0d139715adeaee18aab4bcac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "866c4d043024722b08f01cf857a29733397a87d9ca800458460f412ecb7097d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "866c4d043024722b08f01cf857a29733397a87d9ca800458460f412ecb7097d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "866c4d043024722b08f01cf857a29733397a87d9ca800458460f412ecb7097d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cf453d8234a1935d20971a3e5b07ba84aa4e2f96f388a0a14826460d7d49ed5"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
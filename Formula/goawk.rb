class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://ghproxy.com/https://github.com/benhoyt/goawk/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "56467fe10d184ffaaf47fff7ede29c85be53af8b65c158bf5cab259a0de0a527"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2af1a4e6b57b3b46819f0f1f2ad38778a61ac24eaec8214fb4eb8d49af643c1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2af1a4e6b57b3b46819f0f1f2ad38778a61ac24eaec8214fb4eb8d49af643c1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2af1a4e6b57b3b46819f0f1f2ad38778a61ac24eaec8214fb4eb8d49af643c1c"
    sha256 cellar: :any_skip_relocation, ventura:        "3ab507e5c37571084e011ea5077738c4afe1fba3184cfe32d477fd66d619f464"
    sha256 cellar: :any_skip_relocation, monterey:       "3ab507e5c37571084e011ea5077738c4afe1fba3184cfe32d477fd66d619f464"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ab507e5c37571084e011ea5077738c4afe1fba3184cfe32d477fd66d619f464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa19eb6772a245e6eaaac8228ad7fd2778bda04fbbf0d01b801ed1ea7f3bb16"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
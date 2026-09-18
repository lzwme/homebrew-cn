class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.78.tar.gz"
  sha256 "bd3c02152b44f53b6ad1c339bb10c335856e7756f44f9b97e4e189e09748c399"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "298053e48b2e7c7c6c9adeb5048cfbb6fb8258ad5a5c960484a1d8c39b9bbd12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "298053e48b2e7c7c6c9adeb5048cfbb6fb8258ad5a5c960484a1d8c39b9bbd12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "298053e48b2e7c7c6c9adeb5048cfbb6fb8258ad5a5c960484a1d8c39b9bbd12"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "08cbf388650727d42191b92e36b297795db699c3e9e41c644c963aa3ed55b75b"
    sha256 cellar: :any,                 x86_64_linux:      "41a9c128af1b1d95d543086169fadc7e9b60a57810adb8943b3f60f5cc16504d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
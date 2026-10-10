class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.22.tar.gz"
  sha256 "642510181e9034cc7d9cfe0e5bc0afb7ece4d121f7736e2f31c27d04690c72e2"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a12afd342dee93a57bdf73e1052c8ad6a492423be308eea3318e6b6a9a59684"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a12afd342dee93a57bdf73e1052c8ad6a492423be308eea3318e6b6a9a59684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a12afd342dee93a57bdf73e1052c8ad6a492423be308eea3318e6b6a9a59684"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f43213440b2beeca915f7c688faf9ab13e1021715d640f7a4af9738c234fa1e0"
    sha256 cellar: :any,                 x86_64_linux:      "e2abee1a491e0c79f5282b1a6a133acd5a278b60cfc3684f152d152b0cb6d2b1"
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
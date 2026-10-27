class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.420.tgz"
  sha256 "8619aa06f689a42f0b9fb656c6703679046acdfee74c42db9cfeb3fd79ba5728"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "352f6e91d4908f6be201f5a66fe48e269f36f73182e31efe1070121549bb5d5b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "352f6e91d4908f6be201f5a66fe48e269f36f73182e31efe1070121549bb5d5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "352f6e91d4908f6be201f5a66fe48e269f36f73182e31efe1070121549bb5d5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2a129f56b136cbdbfc5a07d1cf672028333cd29e6b4af47cf1a0fba8f8323e26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8faa9fd8f73277587eebbf9d8ec61d822a805c4c95fb4f902b2226fe93970de5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder --json")
  end
end
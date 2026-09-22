class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.140.tgz"
  sha256 "b1d6d804e2507978f09e7befc507e1c95fe7eb55c4e3ce75d436c970998ed41f"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98a9dbe25be7e327d430a6adc09f2497e8d2559ef78eb91da2abe747dc52cee0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98a9dbe25be7e327d430a6adc09f2497e8d2559ef78eb91da2abe747dc52cee0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98a9dbe25be7e327d430a6adc09f2497e8d2559ef78eb91da2abe747dc52cee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e08c2e93a6e3c061546bf30c2bb4070db4621e5ab7df3a4e0f0d3f19b7044846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7eb2efbe22858c55203a1e27960550160b09e3e199bb83fb8b7296ba7d400fc6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
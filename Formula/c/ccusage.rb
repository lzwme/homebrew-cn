class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.5.0.tgz"
  sha256 "a5bd1d97160e4a7a8991992700aa3378e7411f7ada54ea2a1ca1969115ff2e2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73153c3d7be3c4da26169ff48692dde07e0b35ea569660f8f81b9dd9c48b901f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73153c3d7be3c4da26169ff48692dde07e0b35ea569660f8f81b9dd9c48b901f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73153c3d7be3c4da26169ff48692dde07e0b35ea569660f8f81b9dd9c48b901f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ea12ee3d6fb167163e859e7859869a6ab4f46a8e93ddd98a7ffcee9cf40d625"
    sha256 cellar: :any_skip_relocation, ventura:       "9ea12ee3d6fb167163e859e7859869a6ab4f46a8e93ddd98a7ffcee9cf40d625"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73153c3d7be3c4da26169ff48692dde07e0b35ea569660f8f81b9dd9c48b901f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73153c3d7be3c4da26169ff48692dde07e0b35ea569660f8f81b9dd9c48b901f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output(bin/"ccusage 2>&1", 1)
  end
end
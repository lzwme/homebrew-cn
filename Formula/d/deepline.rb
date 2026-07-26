class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.276.tgz"
  sha256 "000b8d03ea78fdf32def2d5ad088e9ec1efbf72a7cb9f7651d46fdcdffa8efdf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2fe8e44588add9afdb673f927061c69f42f9125bb274650ad25fd8c601ec7f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2fe8e44588add9afdb673f927061c69f42f9125bb274650ad25fd8c601ec7f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2fe8e44588add9afdb673f927061c69f42f9125bb274650ad25fd8c601ec7f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6e0e1816f01509a06c2fd0fc8d76be3e1b3adcb6d719004f58767ef477926e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28f99dee24f563b163a2d7fe7066c860f42da516800f8aa14faddba46905dddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c236707210a5e24785ea1f3ba1c5e7650591eb12c8007bdf794a1b958e855590"
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
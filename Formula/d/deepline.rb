class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.311.tgz"
  sha256 "8a8605250a7d9dff65b224808d5920bb4ad5ad3ea964ab419aa4ae749e3bac19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d6de1933dc85a333586885de28ce4627fb1503137c3d3590dacf6c2e7508850"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d6de1933dc85a333586885de28ce4627fb1503137c3d3590dacf6c2e7508850"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d6de1933dc85a333586885de28ce4627fb1503137c3d3590dacf6c2e7508850"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa6ad64b733dd1ea4dfe4e649ae1b1757107f5ab527beaa79ced695719777154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52fdc82a3a0718e717552de7348b8b2a7f600a121ecf5b9125c07c7d302c4b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37e691cfb39847f84a278d805f760811d902840fb4406813fa91ef260d134e6d"
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
class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.21.2.tgz"
  sha256 "b2cbe1af97e38b743697c234fd5ac07a04999aae461a4b1dfbf1e7bd93eb2da8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e3bfc7c2c2897b094b80d9e0cdb4da35be75755131f5184f9be19f3249a13f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e3bfc7c2c2897b094b80d9e0cdb4da35be75755131f5184f9be19f3249a13f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e3bfc7c2c2897b094b80d9e0cdb4da35be75755131f5184f9be19f3249a13f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3bfaf94e4ed327cb5ba626d65b723c17daa8c6ab4a9ff440ca373a7013da7646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3bfaf94e4ed327cb5ba626d65b723c17daa8c6ab4a9ff440ca373a7013da7646"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shadcn --version")

    pipe_output = pipe_output("#{bin}/shadcn init -d 2>&1", "brew\n")
    assert_match "Project initialization completed.", pipe_output
    assert_path_exists "#{testpath}/brew/components.json"
  end
end
class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.22.0.tgz"
  sha256 "51ea23db4e8d9cc1d3d56ff352a8fa60b70f3e125fcf5c563e585dcb4b0e7cf6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd45f494c1a6f86f764d482fd1fba5dbd0ca68db9d6984fb0f2c91e37515cc7b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd45f494c1a6f86f764d482fd1fba5dbd0ca68db9d6984fb0f2c91e37515cc7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd45f494c1a6f86f764d482fd1fba5dbd0ca68db9d6984fb0f2c91e37515cc7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cc439e7ee5086c2d982465a05b3275e4e840992b081ef401aa8874f377bb7dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cc439e7ee5086c2d982465a05b3275e4e840992b081ef401aa8874f377bb7dc8"
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
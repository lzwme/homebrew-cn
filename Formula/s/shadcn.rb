class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.3.0.tgz"
  sha256 "90311d6f334d3a7510927c07aa81a0691d6575426eadc9cf03e9e3e58e59bddf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9ec45958ae251f2526fa716d04a59e73b4cb6e2d144843b286a929e0b72d17bd"
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
class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.1.1.tgz"
  sha256 "3cb4a4b2801e4c4a8bae3d1b4474302bfbf3459c688aa32d774b153826ac7085"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "96ea657601d89dc72fc81f7bffc5f0d753f4ba660644562829824608fb15de1f"
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
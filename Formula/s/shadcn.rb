class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-3.8.5.tgz"
  sha256 "24b7af646c5afa01c7604dfe8bf3f28090594c7aef3ae5cdfc678ce040b5a55f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e435a0da8920e6de4aa77cd7e0d208e87ae1b86dff2a7459ef8460f8af0e1b79"
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
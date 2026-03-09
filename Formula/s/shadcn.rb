class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.0.2.tgz"
  sha256 "1cf943684395b5d0bdb51e8747257ba6e8345e528de09f25f538b35818360de1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26620f06b3b6a1e38539a8aad472f9bd1685ff18132dfbbc6e35877f9366f4e5"
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
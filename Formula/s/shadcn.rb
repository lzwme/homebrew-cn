class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.8.1.tgz"
  sha256 "daadd4699fdeed48af55b1943f3d52a4f3a8566b52aa93a7585084bb6d80c200"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c6580606d99f352f0e3bd252e1cfe26b515ffbc8b3c540f0dcbcf110b17dd4d"
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
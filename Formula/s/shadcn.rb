class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.9.0.tgz"
  sha256 "53505d752d902474661f8c5c4d52952f6e7b2b7f1adab58e17f6226e77c25b80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4cb146a1e182f5bc6277385078c059b6f25d32da0ecfae1f308a04b0e4b9db28"
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
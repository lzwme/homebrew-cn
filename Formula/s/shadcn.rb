class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.0.6.tgz"
  sha256 "62277995edf5a63bc97606d80a1835aa762b52d757df6622348ada870d2fb4e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f25d84637c4980121333e823fe53213d49fc286242b06a5a54186a5e82f0e2d6"
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
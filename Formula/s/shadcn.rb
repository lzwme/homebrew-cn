class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.0.5.tgz"
  sha256 "b8f5c00de4e9688987eed6abdac7ee18f3183a4f6c0e72a1f10aa732cbe755da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0a534d4250229189b1e01919ea8dd001ef388f804e56bd875c11305c5245509"
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
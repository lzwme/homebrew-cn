class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.6.0.tgz"
  sha256 "bc865a26ea52d516c0ba752ec51540eadc5691170b54d709891d205832d5b729"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c7d7095ef52a97097188cbf6046e8913134664d55b971636fb19e1b4893ed36"
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
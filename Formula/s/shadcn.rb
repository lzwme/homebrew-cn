class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.0.0.tgz"
  sha256 "d1875d453883d89d0a40965ec440cca915afd03ee6d780c076a48772a39cb65c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88332163f955e251753925cb26e5d6cbb80e326c0b89af817aca857c9b662d44"
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
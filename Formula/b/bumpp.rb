class Bumpp < Formula
  desc "Interactive CLI that bumps your version numbers and more"
  homepage "https://github.com/antfu-collective/bumpp"
  url "https://registry.npmjs.org/bumpp/-/bumpp-12.2.0.tgz"
  sha256 "c5f87fbfc3233ca077562dc7acf75bdd8232a56049eded47c39d94e20be9dc72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "714b9ab3b1fef85c1fe8cfd7bf05f16735a52b1ffbec8c13e448f4d365eb5352"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bumpp --version")

    mkdir "repo" do
      system "git", "init"
      (testpath/"repo/package.json").write <<~JSON
        {
          "name": "bumpp-homebrew-test",
          "version": "1.0.0"
        }
      JSON

      system "git", "add", "package.json"
      system "git", "commit", "-m", "Initial commit"

      system bin/"bumpp", "--yes", "--push", "false", "--no-commit", "--release", "patch"

      package_json = (testpath/"repo/package.json").read
      package_hash = JSON.parse(package_json)
      assert_match "1.0.1", package_hash["version"]
    end
  end
end
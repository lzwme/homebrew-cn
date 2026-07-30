class Bumpp < Formula
  desc "Interactive CLI that bumps your version numbers and more"
  homepage "https://github.com/antfu-collective/bumpp"
  url "https://registry.npmjs.org/bumpp/-/bumpp-12.1.0.tgz"
  sha256 "1f9b37c3ce639f0d1edae9772622181737058d69d406d4ce8e4ff0ce22aef56a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9af3df2880a9b047642c41b05f3f8de6401461508adc63ee4dc6c6d5eb612688"
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
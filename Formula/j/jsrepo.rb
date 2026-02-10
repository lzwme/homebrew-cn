class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.3.0.tgz"
  sha256 "9955abf90fb7c6a4b8f72a75f12989800b062c8ac627c9096d6ef24547e321f2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2248c6691d808f20fa00cfafd060de6c0fdf49b70a47c68b795a6e39e8410a49"
    sha256 cellar: :any,                 arm64_sequoia: "98dea6b5c4e89c2e329e5f751a609152cbeed27aaa92be8b885fd20551c48b7d"
    sha256 cellar: :any,                 arm64_sonoma:  "98dea6b5c4e89c2e329e5f751a609152cbeed27aaa92be8b885fd20551c48b7d"
    sha256 cellar: :any,                 sonoma:        "99f82453c6b9873da0e34c81ec544267a73115d54099fc67f1f2fc3707f84556"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eeb47b12ca2600c0beab7b55edf24a2b3fbb7188747584235be6abf718c531f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d80f2080c66ab66a5088c83d8c33b92d70c27aa67fc7632e350e019695d6ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end
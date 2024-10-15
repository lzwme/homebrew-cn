class Repopack < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepopack"
  url "https:registry.npmjs.orgrepopack-repopack-0.1.42.tgz"
  sha256 "e90887c595c6a2afab327269043007290c3799bc074b6c1e18ab3325e09bdefc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "461b68a5002d510c41466872687a76f7d69813a60e752fc95ab504a5a8183401"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}repopack --version")

    (testpath"test_repo").mkdir
    (testpath"test_repotest_file.txt").write("Test content")

    output = shell_output("#{bin}repopack #{testpath}test_repo")
    assert_match "Packing completed successfully!", output
    assert_match <<~EOS, (testpath"repopack-output.txt").read
      ================================================================
      Repository Structure
      ================================================================
      test_file.txt

      ================================================================
      Repository Files
      ================================================================

      ================
      File: test_file.txt
      ================
      Test content
    EOS
  end
end
class PatchPackage < Formula
  desc "Fix broken node modules instantly"
  homepage "https:github.comds300patch-package"
  url "https:registry.npmjs.orgpatch-package-patch-package-8.0.0.tgz"
  sha256 "4d2bd29c0d73a6eb8c43270125998bb7586d4f4128a2f1f7002e69edc5fed8e2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "431f269a2de6319327359c7fe0ce21b7d10b4dfa92bff4557527987a5efb810e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "431f269a2de6319327359c7fe0ce21b7d10b4dfa92bff4557527987a5efb810e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "431f269a2de6319327359c7fe0ce21b7d10b4dfa92bff4557527987a5efb810e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c658029b2ce64459dc717ef566600b5cba4d4228c2c0790769782e4868d550b4"
    sha256 cellar: :any_skip_relocation, ventura:        "c658029b2ce64459dc717ef566600b5cba4d4228c2c0790769782e4868d550b4"
    sha256 cellar: :any_skip_relocation, monterey:       "c658029b2ce64459dc717ef566600b5cba4d4228c2c0790769782e4868d550b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ac48440106abcb40eb35ade08df6ce7f0998ee7c6cf895905350ee23ead3944"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}patch-package 2>&1", 1)
    assert_match "no package.json found for this project", output

    (testpath"package.json").write <<~EOS
      {
        "name": "brewtest",
        "version": "1.0.0"
      }
    EOS

    expected = <<~EOS
      patch-package #{version}
      Applying patches...
      No patch files found
    EOS
    assert_equal expected, shell_output("#{bin}patch-package 2>&1")
  end
end
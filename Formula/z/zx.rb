require "languagenode"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https:github.comgooglezx"
  url "https:registry.npmjs.orgzx-zx-8.1.3.tgz"
  sha256 "f044062b0f4fa172b19fddb1fd873a85eb2cbe8fc6a92c57b36a4fea6c3909d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a6520a4148dce68a5398e12ec8f2848d1f818fb0b1e796fb40707569844262f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a6520a4148dce68a5398e12ec8f2848d1f818fb0b1e796fb40707569844262f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a6520a4148dce68a5398e12ec8f2848d1f818fb0b1e796fb40707569844262f"
    sha256 cellar: :any_skip_relocation, sonoma:         "61f2978658133749c3fb8f2d450f79a9d9359089bf4bc10aad3f836582a4d239"
    sha256 cellar: :any_skip_relocation, ventura:        "61f2978658133749c3fb8f2d450f79a9d9359089bf4bc10aad3f836582a4d239"
    sha256 cellar: :any_skip_relocation, monterey:       "61f2978658133749c3fb8f2d450f79a9d9359089bf4bc10aad3f836582a4d239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4a2f020526e224fc01e55a83d7e2ed917f48ad2d6e5310f921137e03d58f60e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"test.mjs").write <<~EOS
      #!usrbinenv zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    EOS

    output = shell_output("#{bin}zx #{testpath}test.mjs")
    assert_match "name is bar", output
    assert_predicate testpath"bar", :exist?

    assert_match version.to_s, shell_output("#{bin}zx --version")
  end
end
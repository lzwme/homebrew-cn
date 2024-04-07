require "languagenode"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https:github.comgooglezx"
  url "https:registry.npmjs.orgzx-zx-8.0.0.tgz"
  sha256 "11c74b1f9748ba1ec310017a72bb245fbd35c9cbbd4cc587400bb58789768251"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "662c6b9333120b52f2026df10c66ded6db0da4da787d2e62aa24b8be6b282dc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "662c6b9333120b52f2026df10c66ded6db0da4da787d2e62aa24b8be6b282dc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "662c6b9333120b52f2026df10c66ded6db0da4da787d2e62aa24b8be6b282dc1"
    sha256 cellar: :any_skip_relocation, sonoma:         "c314abd04cbab29f82828802dc51943335210889fcd700e0df1c82974465512e"
    sha256 cellar: :any_skip_relocation, ventura:        "c314abd04cbab29f82828802dc51943335210889fcd700e0df1c82974465512e"
    sha256 cellar: :any_skip_relocation, monterey:       "c314abd04cbab29f82828802dc51943335210889fcd700e0df1c82974465512e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "662c6b9333120b52f2026df10c66ded6db0da4da787d2e62aa24b8be6b282dc1"
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
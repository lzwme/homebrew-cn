class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https:github.comgooglezx"
  url "https:registry.npmjs.orgzx-zx-8.1.7.tgz"
  sha256 "893ae3ea2061548b6e5f1ecc29ca8d16854f4757d06555d5a1f6e9f33340e0ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f7a008db7a88d208a0ee8f05e0990f214a7cacecb2be442b49d6d1ced592ae43"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Make the bottles uniform
    inreplace_file = libexec"libnode_moduleszxnode_modules@typesnodeprocess.d.ts"
    inreplace inreplace_file, "usrlocalbin", "#{HOMEBREW_PREFIX}bin"
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
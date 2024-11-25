class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https:github.comgooglezx"
  url "https:registry.npmjs.orgzx-zx-8.2.2.tgz"
  sha256 "7ea784734891cab4238192209c56dda08b7f7a2d67be18ba2955f06b48242ef3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d90e2f32b0ae3482318873ead7ab478dc587e9484c281998f9e6d154331ec1a2"
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
    (testpath"test.mjs").write <<~JAVASCRIPT
      #!usrbinenv zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    JAVASCRIPT

    output = shell_output("#{bin}zx #{testpath}test.mjs")
    assert_match "name is bar", output
    assert_path_exists testpath"bar"

    assert_match version.to_s, shell_output("#{bin}zx --version")
  end
end
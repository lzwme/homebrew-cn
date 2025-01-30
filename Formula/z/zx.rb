class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https:github.comgooglezx"
  url "https:registry.npmjs.orgzx-zx-8.3.1.tgz"
  sha256 "fe6093702e4898e48a05d9d623e19e9971a18f4d64e4605c159e2adbc7b36cba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "636d12e92baff071ff6b638ef473a5ab05e141a8efa7af4b73a165382edcd2b5"
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
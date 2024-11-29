class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https:github.comgooglezx"
  url "https:registry.npmjs.orgzx-zx-8.2.4.tgz"
  sha256 "9ca015ee951e33914a8031f29b03dee7f6cc7e2622daba7afc613d3822304a03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4d6c507d8d62a55039718bc94a20d3d5793d0ef39017ecc55dd3245cab1a4f62"
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
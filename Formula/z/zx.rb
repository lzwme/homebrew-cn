class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://google.github.io/zx/"
  url "https://registry.npmjs.org/zx/-/zx-8.7.2.tgz"
  sha256 "bec25dd9b4fc4d41a2fa128bf8a7a4fd4de93342b57fe6a37bc27b5516cc598b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "330ab2cd845a48f1662a80a114b032f586aae6ed6529e81b8a2d970482d70350"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mjs").write <<~JAVASCRIPT
      #!/usr/bin/env zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    JAVASCRIPT

    output = shell_output("#{bin}/zx #{testpath}/test.mjs")
    assert_match "name is bar", output
    assert_path_exists testpath/"bar"

    assert_match version.to_s, shell_output("#{bin}/zx --version")
  end
end
class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://google.github.io/zx/"
  url "https://registry.npmjs.org/zx/-/zx-8.8.3.tgz"
  sha256 "ea2ec0b8190e12ac54949124503919b167170fb30932dd26bafecc7e749631ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6cc74857d1f957db7b39f6014aedf4b84c9eca2c0033e64fb3a82e3d5853e3fe"
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
class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://google.github.io/zx/"
  url "https://registry.npmjs.org/zx/-/zx-8.4.2.tgz"
  sha256 "b88ec6e8253cb0e8e47923a906d8ab095b1f06afcca901ecd09c2a2bf239ba2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "93e9c2404be1ade00eea374e44c564b709a1607d323ad5fb7825ac60b41cbb28"
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
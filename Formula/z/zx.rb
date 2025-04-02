class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://google.github.io/zx/"
  url "https://registry.npmjs.org/zx/-/zx-8.5.0.tgz"
  sha256 "02b01d68ebbf7e6e10d0248e6a4cf8f52f91e90ff7c564b0672bb9369423e791"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90686492fc8fa5c049b78cb0087bd6a8a582bf395b188008f3b3e1c3e06dec6f"
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
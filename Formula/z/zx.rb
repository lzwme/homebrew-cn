require "languagenode"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https:github.comgooglezx"
  url "https:registry.npmjs.orgzx-zx-8.1.0.tgz"
  sha256 "aeb9483d5f4e2e56b21371f65a57545d93365634be730988b0d808d038d0ea69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57aa3e992eef6c8e13bfd203356ad408a68590946746cbba19da80cb7d7ec68e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30afd6689e49120b33b8753b4f1592c4c763cd0b9d892c4aae4729b267099ee6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eddb4e0974d737f1dccc44fc90113b0cb06844114891af94390c787b4ee69889"
    sha256 cellar: :any_skip_relocation, sonoma:         "29610816129bcdbb1923ff29b55526b3a4bde2db9f59e07513f0c17f9b56c053"
    sha256 cellar: :any_skip_relocation, ventura:        "ea4521b90d79d0dbd9d8b752777257b4c6154951887cb48042a4190109213e57"
    sha256 cellar: :any_skip_relocation, monterey:       "e689f97098f7f6a64ebecd9148176444735216ba7a61fea982616b47ab469ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdf5a2ea9f888670de24208c8acf8621cb8905d8f45be3d301aceee9666a166d"
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
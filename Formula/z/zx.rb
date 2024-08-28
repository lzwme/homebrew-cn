class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https:github.comgooglezx"
  url "https:registry.npmjs.orgzx-zx-8.1.4.tgz"
  sha256 "dfdf71de383d5145c01063dd32fdfee95bbfd145b1470a4b69a995a33c752ca1"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "3cbc1055efd0b053b9d83760d3fe209894a2546a1031c757198a88a70ead82ad"
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
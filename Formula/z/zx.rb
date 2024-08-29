class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https:github.comgooglezx"
  url "https:registry.npmjs.orgzx-zx-8.1.5.tgz"
  sha256 "0e395f2bcaa39240b23a15277e12d17b6d01d81fe0d88250c3654b92fb123107"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2fb0ecb631a497003ec5392cda4ff3b73b845b685025e638370a413b8c547c4a"
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
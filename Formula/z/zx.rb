require "languagenode"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https:github.comgooglezx"
  url "https:registry.npmjs.orgzx-zx-8.1.1.tgz"
  sha256 "c124eaf89b8c38207618c586e9c1955f35d127bd62526946fd916467670b3957"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74f4723f41481bf98d9fb9dbf7ad1b99c3a4fc3faa154e6248d20eea6f1a96a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e19f5408c9c154b3443abaef7eae2f127ca1cfc09b2757348918b9eee325c692"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb5df2f62fa1c8ec17ecf8b82c3754b3ba8d6090fce61ed2e5c8a08bfeb24449"
    sha256 cellar: :any_skip_relocation, sonoma:         "845cc400b35254115573eb85cb85e279c796ec87f0e299ec5ef92b43d4808f9e"
    sha256 cellar: :any_skip_relocation, ventura:        "6a537a11ea704c9cf158e8f1a2ce9b92a8ae0aacbf9a7780a251e03c37aadb8e"
    sha256 cellar: :any_skip_relocation, monterey:       "ac14ebc8013c31075db7b05699405410133d5900b676e021117c125a8cac293b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "616e6e66817e81c5613444ecd6ec119bda40fd8aad3ed9172cd0dd69776d144c"
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
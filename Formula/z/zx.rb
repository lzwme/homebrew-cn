require "languagenode"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https:github.comgooglezx"
  url "https:registry.npmjs.orgzx-zx-8.1.4.tgz"
  sha256 "dfdf71de383d5145c01063dd32fdfee95bbfd145b1470a4b69a995a33c752ca1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "023910f5fa85df09bc6eab9f318cfbe875bec09957522bf6c9fa3d498adbd630"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "023910f5fa85df09bc6eab9f318cfbe875bec09957522bf6c9fa3d498adbd630"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "023910f5fa85df09bc6eab9f318cfbe875bec09957522bf6c9fa3d498adbd630"
    sha256 cellar: :any_skip_relocation, sonoma:         "3900dea2180764d4b5a3dc774cbe2e534b9c4436e189ff29ddd3e5568994e4a7"
    sha256 cellar: :any_skip_relocation, ventura:        "3900dea2180764d4b5a3dc774cbe2e534b9c4436e189ff29ddd3e5568994e4a7"
    sha256 cellar: :any_skip_relocation, monterey:       "3900dea2180764d4b5a3dc774cbe2e534b9c4436e189ff29ddd3e5568994e4a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62e90addbe8a4bdd52245de2095129bd53c1ca162f1894e8b4c278412f555026"
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
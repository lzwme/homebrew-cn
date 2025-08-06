class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-0.0.8.tgz"
  sha256 "8617d25a898b891ad93b6756338293aa58f0160a587b25727d56d3381fe2e3f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "849015a7794c2cac0fd9b4c878495f63fe263dbeca5f570b4a0aad96dce38209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849015a7794c2cac0fd9b4c878495f63fe263dbeca5f570b4a0aad96dce38209"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "849015a7794c2cac0fd9b4c878495f63fe263dbeca5f570b4a0aad96dce38209"
    sha256 cellar: :any_skip_relocation, sonoma:        "067c6616601510f81feac69f876068ca933761bb216369330973f62e12012cf7"
    sha256 cellar: :any_skip_relocation, ventura:       "067c6616601510f81feac69f876068ca933761bb216369330973f62e12012cf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "849015a7794c2cac0fd9b4c878495f63fe263dbeca5f570b4a0aad96dce38209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "849015a7794c2cac0fd9b4c878495f63fe263dbeca5f570b4a0aad96dce38209"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/varlock --version")

    (testpath/".env.schema").write <<~TEXT
      # This is the header, and may contain root decorators
      # @envFlag=APP_ENV
      # @defaultSensitive=false @defaultRequired=false
      # @generateTypes(lang=ts, path=env.d.ts)
      # ---

      # This is a config item comment block and may contain decorators which affect only the item
      # @required @type=enum(dev, test, staging, prod)
      APP_ENV=dev
    TEXT

    assert_match "dev", shell_output("#{bin}/varlock load 2>&1")
  end
end
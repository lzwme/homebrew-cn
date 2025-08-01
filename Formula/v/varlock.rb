class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-0.0.7.tgz"
  sha256 "1d5ed8a1ca5fb54da874a15af01466e85090ca51187fb3864161135050fedea7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c83cd2e2ba7a0ddfebb843cecb2f722894d192c63e005a233e83cc2d252e4627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c83cd2e2ba7a0ddfebb843cecb2f722894d192c63e005a233e83cc2d252e4627"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c83cd2e2ba7a0ddfebb843cecb2f722894d192c63e005a233e83cc2d252e4627"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a3b6863097a176432f1a547376064a5d57cd4677a7b43666dee6c463a5dad71"
    sha256 cellar: :any_skip_relocation, ventura:       "0a3b6863097a176432f1a547376064a5d57cd4677a7b43666dee6c463a5dad71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c83cd2e2ba7a0ddfebb843cecb2f722894d192c63e005a233e83cc2d252e4627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83cd2e2ba7a0ddfebb843cecb2f722894d192c63e005a233e83cc2d252e4627"
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
class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-0.0.11.tgz"
  sha256 "712c090b543420f61332b7faea9082ebaa159e3a61d5710e263e100966421370"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2b4785379f3f8070aa7ce1e3849181e9f23b3ed42a1d8e8f19537bc31447d2d"
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
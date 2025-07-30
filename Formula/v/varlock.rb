class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-0.0.6.tgz"
  sha256 "ada6b2a938351f4f6b1ffeec7a1b4a97b3f9a35c586e44e7dfa7fec94fc47e36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "506af2149a89685fb58e28c2f5e2d41effd22feb0fc0a71e734335d2b1b076c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "506af2149a89685fb58e28c2f5e2d41effd22feb0fc0a71e734335d2b1b076c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "506af2149a89685fb58e28c2f5e2d41effd22feb0fc0a71e734335d2b1b076c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ee7363477cfd62b8dc2304ec235c78d6caeadad323f8ece939f91a8aa608b6c"
    sha256 cellar: :any_skip_relocation, ventura:       "1ee7363477cfd62b8dc2304ec235c78d6caeadad323f8ece939f91a8aa608b6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "506af2149a89685fb58e28c2f5e2d41effd22feb0fc0a71e734335d2b1b076c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "506af2149a89685fb58e28c2f5e2d41effd22feb0fc0a71e734335d2b1b076c8"
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
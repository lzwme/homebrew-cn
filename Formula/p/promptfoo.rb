class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.113.4.tgz"
  sha256 "09f44d8eeaf6155c75535fb98cc38919ec9f14e07c86208c0b8ac50ff688fac1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "16605957bcfca45f83a5e71024a2f3f73ed8b3eb00bcc5f542826664ebe09753"
    sha256 cellar: :any,                 arm64_sonoma:  "134445ca39a2caae6c640872b85fb0ca15a106bd18022f95756d87b87fe873b5"
    sha256 cellar: :any,                 arm64_ventura: "720db986a177392f4d26efcdd343d29a2d08f8718c858be50086683f464145fb"
    sha256                               sonoma:        "0f926e3e30d7dc9bfec2004e65b185c25e04e873c2273d1bdd202c5bbee23e3d"
    sha256                               ventura:       "c1ffbc12c4c26acb1b2c9c58b4c98c99a3937ecc7170cbfc771929dc87288dd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50b556a0ce2e04d495fa948cf5933e01eedf195e7de6631cedb83ab932086d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f371ecd4327f51ddc4b9081061ea505276044f860cf0c07b5ab822d8dfe2028b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
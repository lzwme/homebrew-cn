require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.67.0.tgz"
  sha256 "3c8ff6b3844e73e72bfd0a1dd2c35117f4dd2eff259aba51f7e0d30a7a3a1dc6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbc107ee84fcf1574b44f474308b4b430fbf90b04c1870a9e8c0ad6e32f2fa9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02062a39910a0f984d656fb8ba02832f5ef04211270387458d61de13c4b6f414"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4860e0cf50a26a79861dda89077f7ed6a147c2bdaaebc513c118db48eb309288"
    sha256 cellar: :any_skip_relocation, sonoma:         "30c21ae2a21b9d363dc2e374c33f4420d14a1046541ae91119ab7161cbfd30e4"
    sha256 cellar: :any_skip_relocation, ventura:        "4973521ceddcb8d54ce1550c6c5ab336a95466810763620698b02d6716ad2891"
    sha256 cellar: :any_skip_relocation, monterey:       "c339d47a2425d1493dd61cebe005e9932612c2bf784478333e7fa05b0a787066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f91e8ae5c899ea97fb25b7380fc28afdb992453e6f3a915729ca10c975404999"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
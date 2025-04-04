class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.108.0.tgz"
  sha256 "10934bcc1d7d86ac424cdd57116ab19b64916811e81245e315d46d87f57e0a40"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "31840591fd3dda61dc29b14d8e6dd2b2bd79c1a241f173305d3b1a80b2e9383a"
    sha256 cellar: :any,                 arm64_sonoma:  "32a1e7f3f243c71c5159e9a58b7b47bd352b6f2a69070a570d982a66c611d713"
    sha256 cellar: :any,                 arm64_ventura: "3a8e7e2d8988b4bd80270932e229948c9df407eb0f46439afca1a112c5051551"
    sha256                               sonoma:        "d22aaaaf284929b09fc882f7b3598fba61a3824cd79bde24a5306d470c9578b3"
    sha256                               ventura:       "c3e8a57722460c9114bc0e57c286fcda5d8d1d958f208e81c995b3ab24602fbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ea40c4066508086a2881d010e8ece8b3c52c9a60ec5415603897c8e7ba49fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14aa18bde09569524f697b1ea3c02b8cc3b9c6d1b3e3636ec00180bc4cfc2d7d"
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
class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.102.4.tgz"
  sha256 "493002f5040687f4257311ff0f5faeb6c5b53e4b6488bed97da475ead27bf4d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14a278f2745ce7a5a3a4014f69656afc6c1983f23ab9dd69d2d8d79213904ef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "111acb4d5763e49f118ef152db2b9643f997118225ee896826532ff1d6817c60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bcc3410a447bdf07b520fe75ede67c4bca6931ccb2f8d4ad6999591352bcbff"
    sha256 cellar: :any_skip_relocation, sonoma:        "162bc38a44df165ed618dd99179d37c22e91800a0f21b71fd7fc8be4733fb586"
    sha256 cellar: :any_skip_relocation, ventura:       "1e06bc641054597ea448cbcd4bcbd6a54d80dd21004bbaa0f275e8827d32e107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c612fe6af0dc6de3dd23f07358527713a410381ece53fa71370d55ab08a633de"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
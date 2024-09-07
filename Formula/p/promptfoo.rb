class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.85.0.tgz"
  sha256 "cab329ab3f82802c8758dc457874c6cbdc76eb209000860f4721e0d78e377ad9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8a9622cffb3bcc08d2b5ae10912e89ba94ac43de5604bd0c88fb84441e450a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8593ce02d9dc54105c9e5e9ca3de036748922e860b87b5b0028fbaac4a81b723"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2cbe66f9772e1fe2eb9db0e582a964737d9927dd0181a3bd0e888990dbe4953"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dc0280d1ed21a7fd2aa269e246619c31ab8ed107d11be46ef0ccbba853ba78e"
    sha256 cellar: :any_skip_relocation, ventura:        "501c537354393281b0e973e42e837c497e34071fec5df7691030c656897f66f4"
    sha256 cellar: :any_skip_relocation, monterey:       "c2941c7711af4397696efab719e18a7423f369755bdb80400b753fcfb8fbce86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f98e2a0fa76166823eeec0acf31257b519c3bfbef5718e1be4b1171f440a63ef"
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
require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.66.0.tgz"
  sha256 "1da0337bed0e03c743ff72bedbc52e5e6589a4572fcea7f12a74cd4b4097b2d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f08948b62fd27fb9b0f075699cb2e8fe368bcd79e3a32661fef8dbbbd1c6da41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1292cf3afd4b8569bbe1563d654ce9107e2cb263eac26ae91ff3e99d8c21d26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db26f655e2150929e813849164791ae573c8a24767b87a50b7314c42de1b9d03"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c9cf31ae5662bdea15da007b6e8abf882b8a08ff949ec88ece4f014b80840b1"
    sha256 cellar: :any_skip_relocation, ventura:        "1da196f99860bfdfce95b80096cd6b4b808d23447c63a949afd66db7f16b90e0"
    sha256 cellar: :any_skip_relocation, monterey:       "776039800ac316f91fa231d28f6a1e53b5cf6b3fe9c7a45f5ad0456d3215897f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca6d71a437e30cc0d115da0140f5a7028ba001057ead4f1c1af1278f5df51293"
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
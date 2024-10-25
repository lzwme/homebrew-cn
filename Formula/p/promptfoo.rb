class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.94.1.tgz"
  sha256 "9d3a9ab9d4e5ade0a1640258194d6de40eea46b814bf1d4092a7f1a2d840e95a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43030c8f33afde1e4b46ed9b41697c1cb12e556c9d819e629e75ae47932d8069"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f478b1b4ffcc6d246aa03365df65680424333f23b59bde6b660db93142f9a9cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df0b01e1e8156ad105dc12273358a8a5f198eecc8800dbda479a9902350e5e9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "887b74c756066ceafc825751a6a5a03a3c6d065198cd354919c2c1100f037d85"
    sha256 cellar: :any_skip_relocation, ventura:       "051bed676ecf79740e9f7a053f0c54d819447fb99e70601fd1e2d32a1cf6b016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54bc2730865253b218539d75f9bfc7db61843f2c2767814be934a5d33bf61d08"
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
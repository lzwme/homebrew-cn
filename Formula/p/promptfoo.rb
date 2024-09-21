class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.89.3.tgz"
  sha256 "425550170c828a2a51a868c1a68de9d06265396b24ca80e67e6cf29506d13067"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02c70ecd875335a086b2487b3b96f57e41f34deb3d4f2fc0c2c096a84c442392"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fb3e536e18f16e12452c3ed5be3a336cb78cb187260f1748cdf554437cae5ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2d8060a8dbdfc806bddbf10eeff273a243302902adf84d10bc70b7f6cda4eb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d9fa8685d57f0afa69c0ea9fb94550c1d30408f77172629544da9f7ad37fc50"
    sha256 cellar: :any_skip_relocation, ventura:       "ca5cfd3d502ea7170a9b8949845808d52d8d9ac9667c1db75e0a47b21034936c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbd424761ecb2889cc8ce3783a6a9b1f6da7b697872c4d0b618c184226f960db"
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
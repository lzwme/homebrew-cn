class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.83.1.tgz"
  sha256 "ac98cc7a1a97616cb0f51a70795eac399c1327c946b1bb549476a10e18677af8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "589febc8309e695787db5e8db434b8bc27c5d0b342a72fde012182364f2b6ac7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2efd280e5a7b18ac05e907cd33c21cd12c0edd1bcc052de547e5936776fbff2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "365f268371869b6c6acc0b2461572f810ed09736ff7040a2ac99112edc5c1881"
    sha256 cellar: :any_skip_relocation, sonoma:         "8da3f4fab225210bd05a397feea1bf5ac2973117fc1ccaba3a9083612e0ce580"
    sha256 cellar: :any_skip_relocation, ventura:        "d17ed40b860bac70a8ab0ce70a78d4c85ddebcfbcb9dceb211b07dd5939df61e"
    sha256 cellar: :any_skip_relocation, monterey:       "d8a17efd9eb45a324bdfbc000bb57c9deaced41e0cb25bae2cdc4d569d0f452a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c80298ce8a1e0f7e2c75967d3ff00e885bd8e928b21dacb86e8f5b24b8700fd"
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
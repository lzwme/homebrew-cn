class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.100.5.tgz"
  sha256 "0632fc8dc97ab4833b9cd84485cba93eb4e772eb424ef4af0d11db1c6e61f5bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a19576a05fd9754335189f981d58add70cc03e9adf068625058a07602e50bce9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a9b9983af552d838c9862a7fdba079db8ed5c2cbd1ba366e770c73604c259ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e89af46bf3ab67fe6d576d935f2f9371d0002768e2fe11a1ae10fc2e6576e40"
    sha256 cellar: :any_skip_relocation, sonoma:        "759828763ac1e1a7cfe69e709c6d47f283ba9ebf760a073dcbd3d8cd6da423e4"
    sha256 cellar: :any_skip_relocation, ventura:       "7fb2ea9eed80c491389fb90f6dab72c07f7f40ccd4080b32bf0e115cd51bb2de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf3e471ac1bf7b729be1b79196a7fa29897246dd6fbd44850556b446746c4a4b"
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
class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.115.4.tgz"
  sha256 "4b9f7b31d5f9d0c6ba5bb4f60e19aad264d970155280ac74292c653b8e38d703"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "74bd798cd0ece8f1fb7fe6c291119391d1a9c109525b2be4219df006988dab01"
    sha256 cellar: :any,                 arm64_sonoma:  "bad01b7fa23c233be80d618f98e7ae8e9fe34c071a956f43bf6010357beb5324"
    sha256 cellar: :any,                 arm64_ventura: "04595b75e57c99a203db8101f01a321ffedf9492adf834e044bb5ee12653a03a"
    sha256                               sonoma:        "06af89d689a78bacb2ade88a2255b96df7bda046fda8032813ccb43fe0db0bdc"
    sha256                               ventura:       "7b27d01e190ce5af1d37a8e218bf3ac33e45a173d9357af132990a4fb397d387"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c61bd24d8a51ada0461b8693d568640641deb3a19494af14d900949c6df3a4be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62a68a5d0c961e477d32cec456308fda229d99419d38c22c39a7e379288c6b1a"
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
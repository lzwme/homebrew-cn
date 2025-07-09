class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.116.4.tgz"
  sha256 "bd419deefc896fa60da9414c921f3de0df159733082ccf96dc6de931a66e68a6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4b881c3ba941ba953b0b56b9327a8e8037104dbef56f9dfbf33d0f24c5f3d606"
    sha256 cellar: :any,                 arm64_sonoma:  "e73ca5c86840c6996e796002d8adc2c0a9d863fec6a7e184fb4b28fe9a24ebe6"
    sha256 cellar: :any,                 arm64_ventura: "bbbc9db29a3c4be290aca9769210f52caed1e79f61a4783076b2ad427218fd61"
    sha256                               sonoma:        "29498ddedba65b530ae2f294c262fca297f48a11a24117d58b96662f87e808b8"
    sha256                               ventura:       "c5c047b6c29e52f93d8c22b0d546afbefc171f3e3283758c1ba666f11e719be0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8edd5433df0f032867f8f6dc5f8e0d85534437c38775f68e306ba48056f5d994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5aff7fa4165b5850cad2a8f8b6b926e1746883327b730004d92cdfa58df5126"
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
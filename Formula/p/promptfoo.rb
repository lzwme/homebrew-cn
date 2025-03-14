class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.107.0.tgz"
  sha256 "a25ee1621c3f54c8170d6fd55067f720f65cfc9bee05d809d077143a33ac12ab"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b589c34a910550bd0a8c035c2836dcf937be8bbaf5b61cea63cc64e80b515cb"
    sha256 cellar: :any,                 arm64_sonoma:  "40ee893527d6c088de52f1c51f0c7b3f944ad0c46e81e24929630f4dc35f4334"
    sha256 cellar: :any,                 arm64_ventura: "f53911d233c675eb5e01ed190c827c7fb954f7bdb965bc51266b9b60ef7873ff"
    sha256                               sonoma:        "559a4c3d1f111f742db65548432da18cac1aa4b2bd842c951b8c2af1959b7f55"
    sha256                               ventura:       "e59cc22784742481fe2e8db79d69b63ddaee54692b2adfcb313e56a352f117ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9ea4e0b14fffbfb90fbaea483283dd4965c4491a6853aaceefcaea4517127c8"
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
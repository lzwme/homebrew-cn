class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.113.1.tgz"
  sha256 "881e1844e026ffcaa0965949c9e353bbabc384a83e26f73ec198feea5ddd11b9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "173413b5f959228e9bc12d0b527aecb0e47642065211e13b843d32373fe0432d"
    sha256 cellar: :any,                 arm64_sonoma:  "dd2f39b8359cf6e7020302e411ddd44a748aa25de15fba89c11faf2cec692304"
    sha256 cellar: :any,                 arm64_ventura: "83ccdca9d4e1b34eb02302ef6a96d7ea5329e7bebfeef2c7f15b4222e64cd819"
    sha256                               sonoma:        "d61a0b4861d5baf79c0219563b69356eeb33ca41496fd5982aad2c86a377a530"
    sha256                               ventura:       "8090a87dc3acb81e33e55c35f3fcbc147064ad574710cbcdf4780ed3c310ad84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f210410c2e6deb4ce53af2cc9f1b227bed3fa5ff46dc8fb30d3ac89910a53559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "078c6a49e9acd9e21198c7404e1079d9c3a65126baaf12c580c7f0e695d91a39"
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
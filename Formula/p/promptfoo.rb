class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.114.5.tgz"
  sha256 "30e5aad63572c5d83e90174de554df3ebc6990f256711ad6ba6800b22ce41f7a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "92472e7e0a09f4abcd8f8c7a2677851a90cd8ef8e1647983c8b38cb7654dd4a7"
    sha256 cellar: :any,                 arm64_sonoma:  "0f705fa5e0840d10e3e2b56ed007ac32106ed91e1e2c34209580c7d12583d300"
    sha256 cellar: :any,                 arm64_ventura: "f4acd6ee7729c3c4c39df17ebf2d53377d47c941078265f0e59bed59f72b5c6f"
    sha256                               sonoma:        "24a5678c8a708653fc3859bba92e7ce7738b1acccee0389a1fb7c474dbd59e3e"
    sha256                               ventura:       "3ade35d5f5d38e747cf3ba5bcf43acced803faea9bcb6da5c86326f8d7c5b97a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf5794fdc595d6c94b1cebb4320c02458d9fc8b11adc6fe516cd2851690145a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b99e3332a00f70d260917243fc3b2ae7d86795c901e1121ee66e53d81c1343c"
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
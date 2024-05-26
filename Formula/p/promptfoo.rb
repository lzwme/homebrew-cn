require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.60.0.tgz"
  sha256 "1ff6d635a3973097caa2f4136bd2e26e76d654bf6328a8d758cab71f4eb18fe6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cb2d0fcef0180c714e8bb42cabb996d095e6968c95f0fc3b6b7e2dd38929d46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "396fd22be02bfcf762e61567c1f1a7d7a9447ea7ba20d66a07220e8c024bd212"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4f63731765fedb494d3db9b65e94f26024ad3e2729739e3c097abd858ffd094"
    sha256 cellar: :any_skip_relocation, sonoma:         "779d29ca44528910066eb13cf97b91233b401a3011a82f5c5a09592f3263be03"
    sha256 cellar: :any_skip_relocation, ventura:        "6b049bc6a8d280bd7af8e889ae5e7ade534e0dce55d3e4bda74d08937fa2a170"
    sha256 cellar: :any_skip_relocation, monterey:       "e58964abe1e43c8285ebdc94998d79dda5acf4c95c6bfc96b4586d9f613822b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed24fbbe163be06eca06b209b8d26459051f79a9daf2c29e91b3fb8afc88baaa"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"promptfoo", "init"
    assert_predicate testpath/".promptfoo", :exist?
    assert_match "description: 'My first eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end
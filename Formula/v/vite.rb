require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.8.tgz"
  sha256 "474a62dbe5b684f167f58a3e143f1c9e86134d4645d5f25c2c73e9e89e77938e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c90489b9995601a014040add5f9c4d85e8f700a47bdcde111447f56debd6ce76"
    sha256 cellar: :any,                 arm64_ventura:  "c90489b9995601a014040add5f9c4d85e8f700a47bdcde111447f56debd6ce76"
    sha256 cellar: :any,                 arm64_monterey: "c90489b9995601a014040add5f9c4d85e8f700a47bdcde111447f56debd6ce76"
    sha256 cellar: :any,                 sonoma:         "3d5eaf8d30b091cec9dd0d537eff53b8320094dab62b463171e2813f51d40f34"
    sha256 cellar: :any,                 ventura:        "3d5eaf8d30b091cec9dd0d537eff53b8320094dab62b463171e2813f51d40f34"
    sha256 cellar: :any,                 monterey:       "3d5eaf8d30b091cec9dd0d537eff53b8320094dab62b463171e2813f51d40f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3d4f2e5e5d32f01d76f2040cbd660bca63e40c1ace9f48547ddedad40528da5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
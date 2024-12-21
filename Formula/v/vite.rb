class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.0.5.tgz"
  sha256 "bc98487af2694789a4c47a6e1b8b4c91dee887cff9a6e0f6d183522c0214e85b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a419927d6cc31511ddb6a4543b91e31bca4ea45bf092f338f0f0b2c2a0516291"
    sha256 cellar: :any,                 arm64_sonoma:  "a419927d6cc31511ddb6a4543b91e31bca4ea45bf092f338f0f0b2c2a0516291"
    sha256 cellar: :any,                 arm64_ventura: "a419927d6cc31511ddb6a4543b91e31bca4ea45bf092f338f0f0b2c2a0516291"
    sha256 cellar: :any,                 sonoma:        "bd379de6da6b70f4d39b7af92ccca291ac5c21bceddbe44d80d0d338382193c9"
    sha256 cellar: :any,                 ventura:       "bd379de6da6b70f4d39b7af92ccca291ac5c21bceddbe44d80d0d338382193c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce55025a4973927b1c73938c2bda28ca13cf5e54e73cb7c91d3675945c449b77"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
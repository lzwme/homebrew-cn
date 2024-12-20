class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.0.4.tgz"
  sha256 "cfb8023905ec66e166c38cdeb88f9e008f0f71942829671d27f36e5aa0d849b6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7832dc30e70bdc6ba0024f2d381eb75a64e98ab77677596947474aa44ebd8f85"
    sha256 cellar: :any,                 arm64_sonoma:  "7832dc30e70bdc6ba0024f2d381eb75a64e98ab77677596947474aa44ebd8f85"
    sha256 cellar: :any,                 arm64_ventura: "7832dc30e70bdc6ba0024f2d381eb75a64e98ab77677596947474aa44ebd8f85"
    sha256 cellar: :any,                 sonoma:        "b2cbef345eb3e43f68d3e903f4a7503975acf48a410a77e5c8bcf4a807e96cc8"
    sha256 cellar: :any,                 ventura:       "b2cbef345eb3e43f68d3e903f4a7503975acf48a410a77e5c8bcf4a807e96cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac8e9061f772736fde1e230a9db39c19a12169c0c50b49e8429ad791434a7c1"
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
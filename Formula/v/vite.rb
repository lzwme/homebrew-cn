class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.1.3.tgz"
  sha256 "b79b52cf6b220d79ed1d97d2c97d2a80a38007df12909bf5a3f91b5356a93141"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f3f3974690de291834360cb6ce53de7835548454e92c3e853afd985eef7e913c"
    sha256 cellar: :any,                 arm64_sonoma:  "f3f3974690de291834360cb6ce53de7835548454e92c3e853afd985eef7e913c"
    sha256 cellar: :any,                 arm64_ventura: "f3f3974690de291834360cb6ce53de7835548454e92c3e853afd985eef7e913c"
    sha256 cellar: :any,                 sonoma:        "503e60069d51f8ddfb7cb89db53005ff464681b83080922cc53b619ea9effd86"
    sha256 cellar: :any,                 ventura:       "503e60069d51f8ddfb7cb89db53005ff464681b83080922cc53b619ea9effd86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3087884ead2eb4c310192ba71d515835cc5f21586582846204610efa76710c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1e0a4a4d63ba3203e3eca27f2ff8f52944dca0f8c06c9ed1b70807f44cc5abb"
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
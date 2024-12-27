class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.0.6.tgz"
  sha256 "054c067848fb14477f76494dd2bc36523267918b8a8642ff1f0cd5c9c4719420"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c6d7d5e73360902c5d885676040c254bf199c4761aefc0fbc21853a9e541207f"
    sha256 cellar: :any,                 arm64_sonoma:  "c6d7d5e73360902c5d885676040c254bf199c4761aefc0fbc21853a9e541207f"
    sha256 cellar: :any,                 arm64_ventura: "c6d7d5e73360902c5d885676040c254bf199c4761aefc0fbc21853a9e541207f"
    sha256 cellar: :any,                 sonoma:        "be6e9b3de0a0ff3fad74517471df3bef7c0e7bd7bb58fdba163a944e8cf19fc7"
    sha256 cellar: :any,                 ventura:       "be6e9b3de0a0ff3fad74517471df3bef7c0e7bd7bb58fdba163a944e8cf19fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83fe1ca5eeb433484e53fff553a0a1253e1af335760a0354deb89f5728a6d74b"
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
class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.2.0.tgz"
  sha256 "618d8d574ecaec329f9910ffba7b16b5c6c6893462f470abddd565df763b1109"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "903d23b7109d0c205fcb6ec1261edebd96a57c084af6313ce0614b18c62434af"
    sha256 cellar: :any,                 arm64_sequoia: "903d23b7109d0c205fcb6ec1261edebd96a57c084af6313ce0614b18c62434af"
    sha256 cellar: :any,                 arm64_sonoma:  "903d23b7109d0c205fcb6ec1261edebd96a57c084af6313ce0614b18c62434af"
    sha256 cellar: :any,                 sonoma:        "ceb09080e5bcb2fb523ec48058453d124cbdd4f86cdbd32db2724bb39720e6e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5b95ac1df135394f16aa9ff88a4225010ff00b505b571c12ea04ecb4e515f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccec65a476ec5bc0a1596cebfe226d0a08326f29392307a3de5e1f323ef394ca"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
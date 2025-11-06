class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.2.0.tgz"
  sha256 "ca6a51f8a36627208a924662af5f2b314b5bd7b35b0f3b16ee380394221b6201"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d30782e7546a881bb7038d1a586a05c225bba27c9015f805833f85482c1b58e0"
    sha256 cellar: :any,                 arm64_sequoia: "3fc50f151519103fcf303cd11daeff2d7a6e74f837b7f86adaa7915e0898a0be"
    sha256 cellar: :any,                 arm64_sonoma:  "3fc50f151519103fcf303cd11daeff2d7a6e74f837b7f86adaa7915e0898a0be"
    sha256 cellar: :any,                 sonoma:        "d994a467c165772e9d4d5266610ff3b5d82b4dddd0ed824276c2c1e285be6b26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f76689700bd6b42e6deb9df50f26c92efd16df1700af56066706a1e5dba7c345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97c96428f41c2c1b2e44da3d3a09282d4c536e102e68bb8b61527ebe7d2601c2"
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
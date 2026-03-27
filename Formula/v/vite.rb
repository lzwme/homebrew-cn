class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.3.tgz"
  sha256 "dae897d66a03193233a34d42484e937612ab40eb95a2d742100a22edbba0eb7c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6061c5756224f9cc64d7407a79f0a0db5b7fc75a5d353b3d49188cdd7f48c25"
    sha256 cellar: :any,                 arm64_sequoia: "325ead551b63cb2e506c47bc2f0237af1a7ec0501c370624c4df7778e387dbf9"
    sha256 cellar: :any,                 arm64_sonoma:  "325ead551b63cb2e506c47bc2f0237af1a7ec0501c370624c4df7778e387dbf9"
    sha256 cellar: :any,                 sonoma:        "9ddb63ec305ca8462a8f60e75f8c72ac6e6f00c980d93f5f8fbaf0b05d381cfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c271b0200519b17fe0a5f45d89c3287a62c8d3863706e75747cee242767036c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed631a4926bdabc8cf904d8ad421048382b4b5873e1d7a2dc2125122a82b6326"
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
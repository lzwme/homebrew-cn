class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.0.3.tgz"
  sha256 "f9b5d460c39a43e95fa6e04e7f2133bf79ec7cf1df0090b9108bb00be3679f5d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "315a83be3f8c05f2a7966143a4a6b8b5c4fd34aa69d3e5976d62576bf9cecc09"
    sha256 cellar: :any,                 arm64_sonoma:  "315a83be3f8c05f2a7966143a4a6b8b5c4fd34aa69d3e5976d62576bf9cecc09"
    sha256 cellar: :any,                 arm64_ventura: "315a83be3f8c05f2a7966143a4a6b8b5c4fd34aa69d3e5976d62576bf9cecc09"
    sha256 cellar: :any,                 sonoma:        "29032d5e0d02966fbba5d2bbb6267859a9e88f7077dcea0b0688ccab13066f0f"
    sha256 cellar: :any,                 ventura:       "29032d5e0d02966fbba5d2bbb6267859a9e88f7077dcea0b0688ccab13066f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9638b97dbd894635099c27876b04281908fe9be639c24f24f8d4538a1b4bc0bf"
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
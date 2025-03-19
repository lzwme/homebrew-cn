class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.24.tgz"
  sha256 "d89c6e4e3389b64a6c38334b0f9d9c6eb5152e5d7113105728b7d48dae4f5f6d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0812c9558a99a4e3a5ecea8333ce1ab9d1a5e4beaf0c14cbf9c2e00cda9941f0"
    sha256 cellar: :any,                 arm64_sonoma:  "0812c9558a99a4e3a5ecea8333ce1ab9d1a5e4beaf0c14cbf9c2e00cda9941f0"
    sha256 cellar: :any,                 arm64_ventura: "0812c9558a99a4e3a5ecea8333ce1ab9d1a5e4beaf0c14cbf9c2e00cda9941f0"
    sha256 cellar: :any,                 sonoma:        "374d80e7a1aeca564bd8f3c392859fa628a45c521ef2fd404a6738f2aa14b47c"
    sha256 cellar: :any,                 ventura:       "374d80e7a1aeca564bd8f3c392859fa628a45c521ef2fd404a6738f2aa14b47c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "596c4d1872b45513d71f7ff452cb2bec510fa194c4cc9d5b557b204cb5123b81"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
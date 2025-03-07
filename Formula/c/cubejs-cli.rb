class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.18.tgz"
  sha256 "8a6c1ae19290207201213a8e9bbc87b250601732ee8003c376f07b193defb77e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3b86c803d35ea6a4a6b048019784fca3a54155f636bf2cfd75117f8416fd22e"
    sha256 cellar: :any,                 arm64_sonoma:  "c3b86c803d35ea6a4a6b048019784fca3a54155f636bf2cfd75117f8416fd22e"
    sha256 cellar: :any,                 arm64_ventura: "c3b86c803d35ea6a4a6b048019784fca3a54155f636bf2cfd75117f8416fd22e"
    sha256 cellar: :any,                 sonoma:        "f317781ee4931867e30a75d036a798241dc2b6c160ebd97ec453f2e1cc5e32ad"
    sha256 cellar: :any,                 ventura:       "f317781ee4931867e30a75d036a798241dc2b6c160ebd97ec453f2e1cc5e32ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59d65874cde18c3a83b5cc06f3fe2dc877f7471ed3a3ec67d53aa5551a5a29e7"
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
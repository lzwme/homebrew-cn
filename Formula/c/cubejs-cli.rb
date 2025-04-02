class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.28.tgz"
  sha256 "4dc9f3eca76a20afb20e6d790929f3d2147dc4875990d38cd0a2e3045767779b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3188cccb959114f283674b39351f9d66767328d8816ce8f5ffe767e3686a8abe"
    sha256 cellar: :any,                 arm64_sonoma:  "3188cccb959114f283674b39351f9d66767328d8816ce8f5ffe767e3686a8abe"
    sha256 cellar: :any,                 arm64_ventura: "3188cccb959114f283674b39351f9d66767328d8816ce8f5ffe767e3686a8abe"
    sha256 cellar: :any,                 sonoma:        "1b3ff3ddba0e8ab17e5e2bb4dbbededdea81eecd7e9a3a426d430ae88737e231"
    sha256 cellar: :any,                 ventura:       "1b3ff3ddba0e8ab17e5e2bb4dbbededdea81eecd7e9a3a426d430ae88737e231"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67b0a25d934ebe5227030093cb6c66dc9c9edaca4a99f8b3621a61139ac4c40e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd09b421a044c055f5901982f945a068b0dab1a82fac397652e4c5dfe133eea3"
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
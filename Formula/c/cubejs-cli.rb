class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.74.tgz"
  sha256 "b6ae7bf66f3c603879c77d0ed00625f01ca86b3c9dc80f876c8e95fa9258fcb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25806e87991c0e733ab6be75098abab7bc1975c15de2b521e6ce1476e1a59b1d"
    sha256 cellar: :any,                 arm64_sequoia: "e9d4df78dd4b297075b6e16cb662811de564a3496edc4a97879901321a4330ed"
    sha256 cellar: :any,                 arm64_sonoma:  "e9d4df78dd4b297075b6e16cb662811de564a3496edc4a97879901321a4330ed"
    sha256 cellar: :any,                 sonoma:        "b76fb6bce6cfa705e2063cb43eaaaac336613c57546b357ed73fe8053fff490b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f91dc2869b1de4ddea87f08ae3e0874c2e4144b00c52d8e582d3067dc3d4bedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf0ac8ead44741c6c57f615e22814341fa7335dda41151e6b6b0f67b35ca0f22"
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
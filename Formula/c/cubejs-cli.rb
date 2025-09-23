class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.71.tgz"
  sha256 "c5db09de01766c81f723b67b91f2a083eb2eb05b37e90fdfcaa9dd4c93e2c79f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d8674e4e16e43ca510871db5d5bda0558dd299854e57847f44873057d253c4a"
    sha256 cellar: :any,                 arm64_sequoia: "0a68f73d9520b64945838f17a0aac23d438e25088c00f81d1ce8c2f277f3b7c5"
    sha256 cellar: :any,                 arm64_sonoma:  "0a68f73d9520b64945838f17a0aac23d438e25088c00f81d1ce8c2f277f3b7c5"
    sha256 cellar: :any,                 sonoma:        "b7a5bd937134fdeb856e3f5d1a6b5e448aa09ea4629e7edab9da0d7010d4d9a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e031335a982706e217e8517d9bac4c6c68fe1a3ff20ec2bfb40ba8c86ddd0c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a9d4311397f01ec1b688c0ed407b524d43d9e49de711358dac59a49386c9108"
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
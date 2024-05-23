require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.38.tgz"
  sha256 "de8332870652d8e3aca7d3a23a5d19b7f5aad42edd7bfa4debf966207175ba37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b1401664d1dfb60fd546f2c60257a0164e71bf090f004d8fe4f3b2c35615285b"
    sha256 cellar: :any,                 arm64_ventura:  "9ae0a87d0fa9beed951ffbf5dcdad2a64c44c48c70892c99d811e1a08baa9abc"
    sha256 cellar: :any,                 arm64_monterey: "07b4b70d5530608cf1451d0153296d4e7a51f9ee7eb4033f2178677d882a4030"
    sha256 cellar: :any,                 sonoma:         "b8ac18abd5f38bfb4fd6ffebb0d262966d58161b7326738634828c58fe215685"
    sha256 cellar: :any,                 ventura:        "4553977447d4a868d837537d273a09f0708556dd69dff30dc247fb6d12d32a39"
    sha256 cellar: :any,                 monterey:       "eedc53ce93a0be861d1bf155a893dea7881845955ee795842480200ca6372c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5740b2511d0823e1df3020483cdf4a4116e0c4d75d880f65829efa3f78b7824"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
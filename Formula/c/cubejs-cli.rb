require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.25.tgz"
  sha256 "2ece49fec8b55acec040cde57dffb5c097f22aa0491055d74f175be1ee504ccc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8adf0bdf5aed70edfb54d8562530cf7b8b0a8a3fd7b061c72e00c8d196a1a4db"
    sha256 cellar: :any,                 arm64_ventura:  "8adf0bdf5aed70edfb54d8562530cf7b8b0a8a3fd7b061c72e00c8d196a1a4db"
    sha256 cellar: :any,                 arm64_monterey: "8adf0bdf5aed70edfb54d8562530cf7b8b0a8a3fd7b061c72e00c8d196a1a4db"
    sha256 cellar: :any,                 sonoma:         "7322299cbb40aa675cc0a73b1d7864ecb309f4b8a5b608e3520f92a294d75b4a"
    sha256 cellar: :any,                 ventura:        "7322299cbb40aa675cc0a73b1d7864ecb309f4b8a5b608e3520f92a294d75b4a"
    sha256 cellar: :any,                 monterey:       "7322299cbb40aa675cc0a73b1d7864ecb309f4b8a5b608e3520f92a294d75b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad9f1d65d830299209f6e68e7189cfed3c23afbfbfb7361ee7aac3b3b30d8527"
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
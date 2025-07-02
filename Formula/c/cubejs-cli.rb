class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.30.tgz"
  sha256 "c4db1c7b1572ee9c7e65dec48785313f62cae69deec95df2a896fa9bb1701fdf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5cdbe67fc835866488a0c18f02fc423acb89109833b143b1d2dadecbece7bb1"
    sha256 cellar: :any,                 arm64_sonoma:  "c5cdbe67fc835866488a0c18f02fc423acb89109833b143b1d2dadecbece7bb1"
    sha256 cellar: :any,                 arm64_ventura: "c5cdbe67fc835866488a0c18f02fc423acb89109833b143b1d2dadecbece7bb1"
    sha256 cellar: :any,                 sonoma:        "2b90928712d258014cf432ca831bb62d4d7c2d9df59a9f5079e802be8ccd0f36"
    sha256 cellar: :any,                 ventura:       "2b90928712d258014cf432ca831bb62d4d7c2d9df59a9f5079e802be8ccd0f36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69b1cd3d0de513aed7baf449214160862a8ac757fa1618bab3efc99e1fd56967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2db916337171bf0da5671144c11d38caf4248e3a049bfc53f653fac9137f2f94"
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
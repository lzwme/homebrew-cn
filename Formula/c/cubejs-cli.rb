class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.28.tgz"
  sha256 "d1a138d83ac48a0e8f96bb6148182b85aa9e027ec76059cacded123f28f29fb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "07397b4c49193084ca96afe5174f7b42a650144c980ed4953c3278945344a9f0"
    sha256 cellar: :any,                 arm64_sonoma:  "07397b4c49193084ca96afe5174f7b42a650144c980ed4953c3278945344a9f0"
    sha256 cellar: :any,                 arm64_ventura: "07397b4c49193084ca96afe5174f7b42a650144c980ed4953c3278945344a9f0"
    sha256 cellar: :any,                 sonoma:        "44b5d61e48c2370900f3306656cbdaa80da0b726ff52d3b3a072873cab51e290"
    sha256 cellar: :any,                 ventura:       "44b5d61e48c2370900f3306656cbdaa80da0b726ff52d3b3a072873cab51e290"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e27f73044fca376dd58784697294ad287d050f703a8d655d4c2b2fde325ceb79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca25f12a40ad739b554f8ae6f1b322da87ea2a5088aac915cea30e1dbd1ed2f1"
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
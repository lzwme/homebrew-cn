class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.15.tgz"
  sha256 "e4686d1700f219c285738b400b1a79f8719d48fd333531f11c7528264729a903"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3888bf52de94437aee01c501c1e07599455dd3e113650a0acf6677504609eb99"
    sha256 cellar: :any,                 arm64_sonoma:  "3888bf52de94437aee01c501c1e07599455dd3e113650a0acf6677504609eb99"
    sha256 cellar: :any,                 arm64_ventura: "3888bf52de94437aee01c501c1e07599455dd3e113650a0acf6677504609eb99"
    sha256 cellar: :any,                 sonoma:        "6136384a5fbc79fd399402726841baf0bcf9b83831b3023d5591fe919a0dc12d"
    sha256 cellar: :any,                 ventura:       "6136384a5fbc79fd399402726841baf0bcf9b83831b3023d5591fe919a0dc12d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a048c677e0d993acfb0a613635b4706790c037c1c7a55a77ddd1ec5204eb797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6497aecdb8038816644c6b4913ad8f4d64c63efcd49f600605071937e9d9e93f"
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
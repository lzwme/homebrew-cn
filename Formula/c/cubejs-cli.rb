class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.0.tgz"
  sha256 "f280de290ad1292cda66ad5d678d65c90c9684b4a2969830b048573d2148fea3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "082eff8fec60e6ccad06655040a6476cf9a3e767818547f356b9318c907b4242"
    sha256 cellar: :any,                 arm64_sonoma:  "082eff8fec60e6ccad06655040a6476cf9a3e767818547f356b9318c907b4242"
    sha256 cellar: :any,                 arm64_ventura: "082eff8fec60e6ccad06655040a6476cf9a3e767818547f356b9318c907b4242"
    sha256 cellar: :any,                 sonoma:        "0b4250e253d8c6342de4366d39a5ff5a2afb3a0a1a4dd4609e58cc339e9cd6dc"
    sha256 cellar: :any,                 ventura:       "0b4250e253d8c6342de4366d39a5ff5a2afb3a0a1a4dd4609e58cc339e9cd6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9057be36459dfc24199a04a91dee475a863b60a633d716346fbcc034cad5b4d"
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
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
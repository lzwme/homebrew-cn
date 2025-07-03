class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.31.tgz"
  sha256 "f62727c7a28f19aaa4efb086264a448293a9d1b1c486555472e304605348f7eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4b08e50d9044cd884b91eba939e489447303925fd0b372be177f289da9f6748a"
    sha256 cellar: :any,                 arm64_sonoma:  "4b08e50d9044cd884b91eba939e489447303925fd0b372be177f289da9f6748a"
    sha256 cellar: :any,                 arm64_ventura: "4b08e50d9044cd884b91eba939e489447303925fd0b372be177f289da9f6748a"
    sha256 cellar: :any,                 sonoma:        "966f55ce17ef0f466bf1a13fec6b6c36090f55e0e4bb545b4442c4a6d8016f06"
    sha256 cellar: :any,                 ventura:       "966f55ce17ef0f466bf1a13fec6b6c36090f55e0e4bb545b4442c4a6d8016f06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5dce72f34314573806a13bd6cbe926065d86aed0f9c44563561427a8ae92ce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4224925d650d15f935c12ca31225088cdaa52e911bdaccf1f92feec25d24fbbe"
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
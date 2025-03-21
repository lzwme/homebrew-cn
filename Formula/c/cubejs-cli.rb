class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.25.tgz"
  sha256 "2b288191570f47f481185557385e6860f4f751362e490cadf1c7af5b69d8cbf4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb3773f27338eaefa3adb12623db5e247562ffc4e538ee190dcbffde6bfae1f3"
    sha256 cellar: :any,                 arm64_sonoma:  "cb3773f27338eaefa3adb12623db5e247562ffc4e538ee190dcbffde6bfae1f3"
    sha256 cellar: :any,                 arm64_ventura: "cb3773f27338eaefa3adb12623db5e247562ffc4e538ee190dcbffde6bfae1f3"
    sha256 cellar: :any,                 sonoma:        "d7f3d51cb3baf8ed9010c683d97929e34534003138b3f90edca263cf85912a09"
    sha256 cellar: :any,                 ventura:       "d7f3d51cb3baf8ed9010c683d97929e34534003138b3f90edca263cf85912a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9234faee03395049b0fa8a4549c3b3e9174c769579098dbb09abfee922b3fe80"
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
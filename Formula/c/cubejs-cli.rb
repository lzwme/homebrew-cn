class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.38.tgz"
  sha256 "326cf6bcfd88e07e5d75126c8eb2441d302a0ebc86b43c007f1f5c36f5dbae30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e6db92bbc3e7a2291fab372028362975456414d1e683e73d8006ff85ad04b515"
    sha256 cellar: :any,                 arm64_sonoma:  "e6db92bbc3e7a2291fab372028362975456414d1e683e73d8006ff85ad04b515"
    sha256 cellar: :any,                 arm64_ventura: "e6db92bbc3e7a2291fab372028362975456414d1e683e73d8006ff85ad04b515"
    sha256 cellar: :any,                 sonoma:        "5a6410907211ebda830b477a311e87bf5491d25f66728dbbffe51bdadd2efc90"
    sha256 cellar: :any,                 ventura:       "5a6410907211ebda830b477a311e87bf5491d25f66728dbbffe51bdadd2efc90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55cadd933a9ada7c0cc449300a39b189a3c07756bb30eace67f288e3ff1d350e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "503850ee45a7ed7f36b674046f2f863b024536aadbff4cbde39b756c262788f7"
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
class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.79.tgz"
  sha256 "7f5ab5f8aeb02b3c7193c2e4e386ab203b6fe2ee0920654249b74ef94eee4b92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c1371c1aee0d42f8ba29679feacdcecca343a131b69cfb2f9efdd4b5357090c"
    sha256 cellar: :any,                 arm64_sequoia: "a86de0f84de1c0cb56371cc3cd41137f40a72cacb02d8dac96c6d24f44194fe3"
    sha256 cellar: :any,                 arm64_sonoma:  "a86de0f84de1c0cb56371cc3cd41137f40a72cacb02d8dac96c6d24f44194fe3"
    sha256 cellar: :any,                 sonoma:        "d77968425958e17751a4504f3286015e4a32f61ba483d770b2fa29ddf065e3fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c75c1ef97a1dc2339d962c66e25584a8928079257e84b2bb2954042631c3ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7293b8e1b35fa91a93c72df98f6daaa3935d6975b010a0bfc30f0b8027b6b7cc"
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
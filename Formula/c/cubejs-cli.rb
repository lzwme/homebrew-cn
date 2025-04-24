class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.7.tgz"
  sha256 "ffc0a313b25864cb9bcf82335d0e4bdfda0cfcaf8981bd5dad060ade9f99aeb7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f2c0795ecbd6740b3875bb69d07d002b8dd0d7bd292a0d75fb611440bf36e49"
    sha256 cellar: :any,                 arm64_sonoma:  "7f2c0795ecbd6740b3875bb69d07d002b8dd0d7bd292a0d75fb611440bf36e49"
    sha256 cellar: :any,                 arm64_ventura: "7f2c0795ecbd6740b3875bb69d07d002b8dd0d7bd292a0d75fb611440bf36e49"
    sha256 cellar: :any,                 sonoma:        "246b10c83717f264e907e6048d748459f906cfb732f9c48413d9650304bc15fa"
    sha256 cellar: :any,                 ventura:       "246b10c83717f264e907e6048d748459f906cfb732f9c48413d9650304bc15fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2f1396994b080c97c13d929563023ccfa20d2cc018adf3e80f165f31acd6245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "023a89f8d9ce1fe493bb68977d28218fca7a5f4c9bc24e679dd590ee039c56df"
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
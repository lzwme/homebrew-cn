require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.9.tgz"
  sha256 "381ef668f2008afe4e34e14b6131451001185cf845dbaa023d9d682c9a7f25ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ca22add7d0aba02d88e7ad125852cb1eceb255c14b50ada48f5634ca8468482b"
    sha256 cellar: :any,                 arm64_ventura:  "ca22add7d0aba02d88e7ad125852cb1eceb255c14b50ada48f5634ca8468482b"
    sha256 cellar: :any,                 arm64_monterey: "ca22add7d0aba02d88e7ad125852cb1eceb255c14b50ada48f5634ca8468482b"
    sha256 cellar: :any,                 sonoma:         "29c9c542d84da5ce0c27f178de1929a2b0e1190a5465f57d38889748e58593eb"
    sha256 cellar: :any,                 ventura:        "29c9c542d84da5ce0c27f178de1929a2b0e1190a5465f57d38889748e58593eb"
    sha256 cellar: :any,                 monterey:       "29c9c542d84da5ce0c27f178de1929a2b0e1190a5465f57d38889748e58593eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4450e3790f994e9c4331d5051f20de99a948d1ff0b192f207c13bb62ea95363f"
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
require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.43.tgz"
  sha256 "5964000318d6b545738a0e04cc72c7d932145a453c552090d13a96f8d0591ebf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dbf7c07f890050e2ca35b21f6097651a413ad8e6920e5cdd5d480ad3c0888788"
    sha256 cellar: :any,                 arm64_ventura:  "dbf7c07f890050e2ca35b21f6097651a413ad8e6920e5cdd5d480ad3c0888788"
    sha256 cellar: :any,                 arm64_monterey: "dbf7c07f890050e2ca35b21f6097651a413ad8e6920e5cdd5d480ad3c0888788"
    sha256 cellar: :any,                 sonoma:         "3cdb10f4905c164980a9018a348f939fb96077fe65b978938183baef743f80b2"
    sha256 cellar: :any,                 ventura:        "3cdb10f4905c164980a9018a348f939fb96077fe65b978938183baef743f80b2"
    sha256 cellar: :any,                 monterey:       "3cdb10f4905c164980a9018a348f939fb96077fe65b978938183baef743f80b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85e8fec17ec95a906cdbb2e19daf73d9fa69d0b93ba33652c88f25b9ca3c4f8a"
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
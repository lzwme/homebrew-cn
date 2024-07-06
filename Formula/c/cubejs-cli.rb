require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.57.tgz"
  sha256 "d17816a1cdcfe54e71ab07dd455db7321d406a1f354017d4480d066141e6230a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7bd3b94f3477a51545c4fe2bd36c4daa86835bb5d2f64cf999e38f6cf0baca34"
    sha256 cellar: :any,                 arm64_ventura:  "7bd3b94f3477a51545c4fe2bd36c4daa86835bb5d2f64cf999e38f6cf0baca34"
    sha256 cellar: :any,                 arm64_monterey: "7bd3b94f3477a51545c4fe2bd36c4daa86835bb5d2f64cf999e38f6cf0baca34"
    sha256 cellar: :any,                 sonoma:         "c6e2c510bb1a309cde7261ebdfbbdbfbf2ea142cc5c5d930812c151b88ecde4a"
    sha256 cellar: :any,                 ventura:        "c6e2c510bb1a309cde7261ebdfbbdbfbf2ea142cc5c5d930812c151b88ecde4a"
    sha256 cellar: :any,                 monterey:       "c6e2c510bb1a309cde7261ebdfbbdbfbf2ea142cc5c5d930812c151b88ecde4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8399cbe771fd01076330addb7a5c556a199839bcd112b1a69f39c1bacfac74a8"
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
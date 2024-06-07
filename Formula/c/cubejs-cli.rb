require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.46.tgz"
  sha256 "fcda07165b25d21a42a964f1c4d8dd80fdfdd24001fd8bf24c076dcbde531dd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "14a9a4c1a0f0e571c099d3068411ec3752e94c5ffbfce72eb67ac7f4c0a71ce5"
    sha256 cellar: :any,                 arm64_ventura:  "14a9a4c1a0f0e571c099d3068411ec3752e94c5ffbfce72eb67ac7f4c0a71ce5"
    sha256 cellar: :any,                 arm64_monterey: "14a9a4c1a0f0e571c099d3068411ec3752e94c5ffbfce72eb67ac7f4c0a71ce5"
    sha256 cellar: :any,                 sonoma:         "5ac91e0a58494b61d1720efcfb0f33220dd416df0e8829b8dbfef32506e70a8d"
    sha256 cellar: :any,                 ventura:        "5ac91e0a58494b61d1720efcfb0f33220dd416df0e8829b8dbfef32506e70a8d"
    sha256 cellar: :any,                 monterey:       "5ac91e0a58494b61d1720efcfb0f33220dd416df0e8829b8dbfef32506e70a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "567cf869834da11f8a979f51dec6bace46e820abe3a3ae2909b62c4739a2f02d"
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
require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.7.tgz"
  sha256 "c832f2ee2e5ca25a4d32ac5a1067b1bd9b3340e67585a12678736f172f25a898"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "773c5b6f2a514dac4037de398f12d2082ed04c3122482770a48568621230c4ec"
    sha256 cellar: :any,                 arm64_ventura:  "773c5b6f2a514dac4037de398f12d2082ed04c3122482770a48568621230c4ec"
    sha256 cellar: :any,                 arm64_monterey: "773c5b6f2a514dac4037de398f12d2082ed04c3122482770a48568621230c4ec"
    sha256 cellar: :any,                 sonoma:         "009529bebca046ed6d8525ed90fa71ddbcea7d30b7557d84c3e0b49ed6d6af7e"
    sha256 cellar: :any,                 ventura:        "009529bebca046ed6d8525ed90fa71ddbcea7d30b7557d84c3e0b49ed6d6af7e"
    sha256 cellar: :any,                 monterey:       "009529bebca046ed6d8525ed90fa71ddbcea7d30b7557d84c3e0b49ed6d6af7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e448c5f2e50c467569462ed8352dd27d70bfd556adc4d0b2513f3351a7eec971"
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
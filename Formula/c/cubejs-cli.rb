require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.34.tgz"
  sha256 "2c48bbd73a21572ce2b46be816c7e3c42c0109bc98d058b555047923280fd593"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fb3eac65c710ad1c041afac9388e422d9a673e84032d02913c586f138a5f2e9d"
    sha256 cellar: :any,                 arm64_ventura:  "30b52a3eb461fdd54f6073740fb640585487645c7ea0081a162e2e8d689e8c7a"
    sha256 cellar: :any,                 arm64_monterey: "24896417abd83870b448043d505634c9d05db66b7bf97843d2f28b1aaf31be5c"
    sha256 cellar: :any,                 sonoma:         "58165968c2c60d5fe8ed66d72dba7d5afd785746438b9e57afce7c399efd100a"
    sha256 cellar: :any,                 ventura:        "841f975f443e4ef7acd8d44702429dd06b38f995fc2d52e03f4985be2550b7f8"
    sha256 cellar: :any,                 monterey:       "906e2bc78999b495a9b59347f8f483392374a2446667308f054b1dee54c5fc1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f37aec0f59ea7d8ef1edfedd477593c876da14e47e77564a59277300cbfb44f9"
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
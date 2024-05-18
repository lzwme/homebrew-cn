require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.36.tgz"
  sha256 "ea3e1b95498f3fe2db37f15721ccc6340f5a571aa56d7a288604af58e0e7e169"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d4e65699c0c5feab5f35c6966f199782109b9cb69e9388282b995b92ba1e08e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc0573d260e1b23dc42139c01fa55416f8d4d00658ebfee09c87e993d75b865b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45b26541858ffafcf96d752aa64d841626a2f3ee1d4364935cbfb6213fc8744b"
    sha256 cellar: :any,                 sonoma:         "663fbe05955a6aaa3721a503aa3780eec49dca0179561ee2c57c338d47df05ef"
    sha256 cellar: :any,                 ventura:        "37b1d2f713c9f79c6cd2f327128a7adbf4592e1198558a18a8de8ee36087abe8"
    sha256 cellar: :any,                 monterey:       "b4ac59e53848f6fae83da31ba7651989e80dc72f84b425334f4ac6a1f650cdd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dff0547f532e78d9cab93b3a8f0b13a6069d471e281154a605d60f68cfa75a4b"
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
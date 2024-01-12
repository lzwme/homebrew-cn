require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.43.tgz"
  sha256 "e105901be917134787e296a9fea97c3a6c5c9f4618659917ecfd087458a57bc6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "ed1fb44040946e4796c1cf74f653cf3e2e7b7bfbda6a37f8ae5cfdcd0fc8c6df"
    sha256 cellar: :any, arm64_ventura:  "ed1fb44040946e4796c1cf74f653cf3e2e7b7bfbda6a37f8ae5cfdcd0fc8c6df"
    sha256 cellar: :any, arm64_monterey: "ed1fb44040946e4796c1cf74f653cf3e2e7b7bfbda6a37f8ae5cfdcd0fc8c6df"
    sha256 cellar: :any, sonoma:         "5c6ac89d7d049fa8561c955737dacf2b304e6eaff518d6acfa2a3205a8c251ac"
    sha256 cellar: :any, ventura:        "5c6ac89d7d049fa8561c955737dacf2b304e6eaff518d6acfa2a3205a8c251ac"
    sha256 cellar: :any, monterey:       "5c6ac89d7d049fa8561c955737dacf2b304e6eaff518d6acfa2a3205a8c251ac"
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
class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.6.tgz"
  sha256 "8d91326cc0a447fb6cc135d2199ac27ec8071f84395464f8994289ebb7e7c238"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e20a4bf154cfb8a3ec19726599da07293f5d009e2a1a07a6981cbfea3159f137"
    sha256 cellar: :any,                 arm64_sonoma:  "e20a4bf154cfb8a3ec19726599da07293f5d009e2a1a07a6981cbfea3159f137"
    sha256 cellar: :any,                 arm64_ventura: "e20a4bf154cfb8a3ec19726599da07293f5d009e2a1a07a6981cbfea3159f137"
    sha256 cellar: :any,                 sonoma:        "e655709305bcc6e515c8717354b99455e3633d3744aa61349cc64df9d1905f34"
    sha256 cellar: :any,                 ventura:       "e655709305bcc6e515c8717354b99455e3633d3744aa61349cc64df9d1905f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e68935515d146ebfbb3aaf1befc9966187f4400ead5059dfd4ec076b8ec50b4"
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
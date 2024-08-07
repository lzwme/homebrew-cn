class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.66.tgz"
  sha256 "3c2d500c84b7b6e8f8d793f5e1e3ffee6c3928532cc1ada97c464ab590b98436"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2e13e977e3b8cfae8dc10e4e667b9a9943af936fedb7a9bac922ca97cabd3fd8"
    sha256 cellar: :any,                 arm64_ventura:  "2e13e977e3b8cfae8dc10e4e667b9a9943af936fedb7a9bac922ca97cabd3fd8"
    sha256 cellar: :any,                 arm64_monterey: "2e13e977e3b8cfae8dc10e4e667b9a9943af936fedb7a9bac922ca97cabd3fd8"
    sha256 cellar: :any,                 sonoma:         "ceea5e589f27096e1766930dde880c0163aceafbe636cd7823c4aa7d1d8ef17c"
    sha256 cellar: :any,                 ventura:        "ceea5e589f27096e1766930dde880c0163aceafbe636cd7823c4aa7d1d8ef17c"
    sha256 cellar: :any,                 monterey:       "ceea5e589f27096e1766930dde880c0163aceafbe636cd7823c4aa7d1d8ef17c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7972881d9e57ed755e202894d7719c28a38699302776fbd2e43101e33eb3e9d1"
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
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
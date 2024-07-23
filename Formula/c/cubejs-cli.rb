require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.62.tgz"
  sha256 "7a39642438ea1297df746e1ebfdbb540c765a71d4e5a20a0af3cf1d535d224a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4d371a3be06733037c5f6743c3491663a09faf4a41be6532c3aad0bc250aee80"
    sha256 cellar: :any,                 arm64_ventura:  "4d371a3be06733037c5f6743c3491663a09faf4a41be6532c3aad0bc250aee80"
    sha256 cellar: :any,                 arm64_monterey: "4d371a3be06733037c5f6743c3491663a09faf4a41be6532c3aad0bc250aee80"
    sha256 cellar: :any,                 sonoma:         "b47f82ee963e2a41533c59a197e8c513b6c0f7ca1e30a681fa57f2b00f25663c"
    sha256 cellar: :any,                 ventura:        "b47f82ee963e2a41533c59a197e8c513b6c0f7ca1e30a681fa57f2b00f25663c"
    sha256 cellar: :any,                 monterey:       "b47f82ee963e2a41533c59a197e8c513b6c0f7ca1e30a681fa57f2b00f25663c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2120125cab3a81ea61b0b926c0c57193ef10bc29ba98a8cf81d0d2e9e232d02d"
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
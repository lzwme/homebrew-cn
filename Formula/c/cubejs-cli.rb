require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.54.tgz"
  sha256 "d00a13dcad71c99384db4a7c19752fa2269501bd6c39bc4a22cbc34c1d8e4b61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "658cb62387dea27c3a897749da200075c8c5c429b5a124649087fe6eec14a64a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "658cb62387dea27c3a897749da200075c8c5c429b5a124649087fe6eec14a64a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "658cb62387dea27c3a897749da200075c8c5c429b5a124649087fe6eec14a64a"
    sha256 cellar: :any,                 sonoma:         "0ba76020a378a2c07bd499b4fb90749db6936a228746e2b57f4478a865da7669"
    sha256 cellar: :any,                 ventura:        "0ba76020a378a2c07bd499b4fb90749db6936a228746e2b57f4478a865da7669"
    sha256 cellar: :any_skip_relocation, monterey:       "b78bcaedce7d07f850fb26d0338329bb1f37d18be0542d962759bb19cda75f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59d51d28d99e73e7cc85f1a2c0f46febd23597c4d57bd225965ba1dc0eac3d51"
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
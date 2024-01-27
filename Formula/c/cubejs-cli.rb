require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.49.tgz"
  sha256 "1c815d18924450b780980b393d2e7816c1a4a109ab4a9006d56cc50aea0815df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "2e93bfb8a0e84495ffc5622b511f4f0f96de1cb2b23691c30b47e47ec5b2670a"
    sha256 cellar: :any, arm64_ventura:  "2e93bfb8a0e84495ffc5622b511f4f0f96de1cb2b23691c30b47e47ec5b2670a"
    sha256 cellar: :any, arm64_monterey: "2e93bfb8a0e84495ffc5622b511f4f0f96de1cb2b23691c30b47e47ec5b2670a"
    sha256 cellar: :any, sonoma:         "ce904cf0f4f91ca641c6635c2f03632b0dd9afe06b23fcd69704a34b35a39a99"
    sha256 cellar: :any, ventura:        "ce904cf0f4f91ca641c6635c2f03632b0dd9afe06b23fcd69704a34b35a39a99"
    sha256 cellar: :any, monterey:       "ce904cf0f4f91ca641c6635c2f03632b0dd9afe06b23fcd69704a34b35a39a99"
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
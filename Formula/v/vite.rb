require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.3.0.tgz"
  sha256 "d4ac482a6cbb2195d24997a9d598a22c1f25f903f60881be5d6bdc43f7703dbf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "614045fd02bb8f27c2c43d06f5b1b0522082f4f46282656b743820a55d93c5f2"
    sha256 cellar: :any,                 arm64_ventura:  "614045fd02bb8f27c2c43d06f5b1b0522082f4f46282656b743820a55d93c5f2"
    sha256 cellar: :any,                 arm64_monterey: "614045fd02bb8f27c2c43d06f5b1b0522082f4f46282656b743820a55d93c5f2"
    sha256 cellar: :any,                 sonoma:         "d86c058b7f47bd31d21b6834e77cbd267c3f0d21f349988aa9308553f42b3078"
    sha256 cellar: :any,                 ventura:        "d86c058b7f47bd31d21b6834e77cbd267c3f0d21f349988aa9308553f42b3078"
    sha256 cellar: :any,                 monterey:       "d86c058b7f47bd31d21b6834e77cbd267c3f0d21f349988aa9308553f42b3078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ef7a4defc3f7b9313b3319965cf17b7104a869222c563ca63c43cf471faec91"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
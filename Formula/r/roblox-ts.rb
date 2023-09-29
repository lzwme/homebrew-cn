require "language/node"

class RobloxTs < Formula
  desc "TypeScript-to-Luau Compiler for Roblox"
  homepage "https://roblox-ts.com/"
  url "https://registry.npmjs.org/roblox-ts/-/roblox-ts-2.1.1.tgz"
  sha256 "e7a96200b32c2cb718e81b34b3b41f2357133bff6eb37d68951dfb5d468c57d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8daeaa87ae9995d8629dc0b11e2ca76951fda288db335db6ac9ba0375cbff96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2d24279737b3f3ec1ea3819f6bb7e0211dee145abb7b734bb50629eec72816e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2d24279737b3f3ec1ea3819f6bb7e0211dee145abb7b734bb50629eec72816e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2d24279737b3f3ec1ea3819f6bb7e0211dee145abb7b734bb50629eec72816e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff78b9e0d06d01b7286f76094048421985718638dbf18dc2925bfc12cbb6b648"
    sha256 cellar: :any_skip_relocation, ventura:        "e47198bf020979ae3f58772a80c154dfc6aabe7d22fcaf82f0b71e9c9b2acd0a"
    sha256 cellar: :any_skip_relocation, monterey:       "e47198bf020979ae3f58772a80c154dfc6aabe7d22fcaf82f0b71e9c9b2acd0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e47198bf020979ae3f58772a80c154dfc6aabe7d22fcaf82f0b71e9c9b2acd0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81719e82abc57fb2340dc542712915b588eeb73089f8adffd1588d9aef91522c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    system bin/"rbxtsc", "init", "game", "-y"
    assert_predicate testpath/"package.json", :exist?
    assert_predicate testpath/"package-lock.json", :exist?
  end
end
class Corepack < Formula
  require "languagenode"

  desc "Package acting as bridge between Node projects and their package managers"
  homepage "https:github.comnodejscorepack"
  url "https:registry.npmjs.orgcorepack-corepack-0.23.0.tgz"
  sha256 "25920d16d1b6ccaa954ab2352b078c8f4107234c511ce9e8bd755f1413909783"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.orgcorepacklatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "539969a3253c98fe6c2626671b06773457ac0bdca6244da8a950675e47d0ae4b"
  end

  depends_on "node"

  conflicts_with "hadoop", because: "both install `yarn` binaries"
  conflicts_with "yarn", because: "both install `yarn` and `yarnpkg` binaries"
  conflicts_with "pnpm", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"corepack"

    (testpath"package.json").write('{"name": "test"}')
    system bin"yarn", "add", "jquery"
    system bin"yarn", "add", "fsevents", "--build-from-source=true" if OS.mac?

    (testpath"package.json").delete
    system "#{bin}pnpm", "init"
    assert_predicate testpath"package.json", :exist?, "package.json must exist"
  end
end
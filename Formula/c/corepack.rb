class Corepack < Formula
  require "languagenode"

  desc "Package acting as bridge between Node projects and their package managers"
  homepage "https:github.comnodejscorepack"
  url "https:registry.npmjs.orgcorepack-corepack-0.25.2.tgz"
  sha256 "4f387861fb786183c9921db0dc5a37c733ec4ae3ac5d6cbbb7f70e664ba03538"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.orgcorepacklatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62dcab4d6c5b4326800f151b8463364f634d55a0d5c87ea1bbc86510c1c1592b"
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
class Corepack < Formula
  require "languagenode"

  desc "Package acting as bridge between Node projects and their package managers"
  homepage "https:github.comnodejscorepack"
  url "https:registry.npmjs.orgcorepack-corepack-0.26.0.tgz"
  sha256 "0593c2ef1ff4aa4189c970294ca0063f4cbf7dcda936ee5a411ac9bdb5c422d0"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.orgcorepacklatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "219e79e0fe176eb914e0d895851558229827911b43ceaa6abfdf08c5971e5067"
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
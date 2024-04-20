class Corepack < Formula
  require "languagenode"

  desc "Package acting as bridge between Node projects and their package managers"
  homepage "https:github.comnodejscorepack"
  url "https:registry.npmjs.orgcorepack-corepack-0.27.0.tgz"
  sha256 "c6627a43b4d6c44ccc504fe27815b5c602e9207435ec9d11bcb1faa095019aba"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.orgcorepacklatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95f4ea2e93bc5b53581948b9c1a04566b8c669e7c7bd046e6b698a2a57a55384"
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
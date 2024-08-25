class Corepack < Formula
  desc "Package acting as bridge between Node projects and their package managers"
  homepage "https:github.comnodejscorepack"
  url "https:registry.npmjs.orgcorepack-corepack-0.29.3.tgz"
  sha256 "63b88391da952a8c977e1e85db734bfa975805cf22c1c5dc5dc9e54eb9eed97e"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.orgcorepacklatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "7d90b3f17059a78d6b20c20afe53e1d6d91484af19bff3c8256a61d79b2e3414"
  end

  depends_on "node"

  conflicts_with "hadoop", because: "both install `yarn` binaries"
  conflicts_with "yarn", because: "both install `yarn` and `yarnpkg` binaries"
  conflicts_with "pnpm", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"corepack"

    (testpath"package.json").write('{"name": "test"}')
    system bin"yarn", "add", "jquery"
    system bin"yarn", "add", "fsevents", "--build-from-source=true" if OS.mac?

    (testpath"package.json").delete
    system bin"pnpm", "init"
    assert_predicate testpath"package.json", :exist?, "package.json must exist"
  end
end
class Corepack < Formula
  require "languagenode"

  desc "Package acting as bridge between Node projects and their package managers"
  homepage "https:github.comnodejscorepack"
  url "https:registry.npmjs.orgcorepack-corepack-0.29.2.tgz"
  sha256 "ad3422b0fd8d268f7bd2e147f22b126a1de957a3b526bbfc3cf7cb8b3906dd2c"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.orgcorepacklatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c1a1f72a4a943c3193e5234a6534e7db50aad3d5e55cc948da361df3b8f3c6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c1a1f72a4a943c3193e5234a6534e7db50aad3d5e55cc948da361df3b8f3c6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c1a1f72a4a943c3193e5234a6534e7db50aad3d5e55cc948da361df3b8f3c6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c1a1f72a4a943c3193e5234a6534e7db50aad3d5e55cc948da361df3b8f3c6f"
    sha256 cellar: :any_skip_relocation, ventura:        "2c1a1f72a4a943c3193e5234a6534e7db50aad3d5e55cc948da361df3b8f3c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "2c1a1f72a4a943c3193e5234a6534e7db50aad3d5e55cc948da361df3b8f3c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15032df098cd4d1875fee60a134b6aa9816956ae304a79e6164ff5167766f81f"
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
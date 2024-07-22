class Corepack < Formula
  require "languagenode"

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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0b716c6d5870ae96d8babde7ec28d9273d4339484dba225fb61a492afb19405"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0b716c6d5870ae96d8babde7ec28d9273d4339484dba225fb61a492afb19405"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0b716c6d5870ae96d8babde7ec28d9273d4339484dba225fb61a492afb19405"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0b716c6d5870ae96d8babde7ec28d9273d4339484dba225fb61a492afb19405"
    sha256 cellar: :any_skip_relocation, ventura:        "e0b716c6d5870ae96d8babde7ec28d9273d4339484dba225fb61a492afb19405"
    sha256 cellar: :any_skip_relocation, monterey:       "e0b716c6d5870ae96d8babde7ec28d9273d4339484dba225fb61a492afb19405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c47f93a081f5178b14c191f8135acfff177df34e5d69719665315e67e538ea4b"
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
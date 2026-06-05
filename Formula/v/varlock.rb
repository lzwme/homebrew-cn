class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.5.0.tgz"
  sha256 "d2550e24ad36863771698f6c46ed019496282501e270c884d57c51d08812767b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1349dbd30093575c68ecda846f732fae7f34c240ebd37e453f148a4a54307755"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61da83dbcf051d6465c2f6c30bdebcfe36d1afeb1774ece5055d6d3fb27e42a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61da83dbcf051d6465c2f6c30bdebcfe36d1afeb1774ece5055d6d3fb27e42a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a02cf98cd77f12f186e42dc4670fbbe18909aef16115e5de70a3a678db4e2e43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8ddfcdce001d1f67641b08d8d147548a9befc57195d6eb97c92d504f1d690df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d12c490babb2012356f2c82638d370fce37e4a341e49851e6be201dde92836ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    mac_bin = "VarlockEnclave.app/Contents/MacOS/varlock-local-encrypt"
    libexec.glob("lib/node_modules/varlock/native-bins/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if OS.linux? && basename != "linux-#{arch}"
      deuniversalize_machos dir/mac_bin if OS.mac? && basename == "darwin"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/varlock --version")

    (testpath/".env.schema").write <<~TEXT
      # This is the header, and may contain root decorators
      # @envFlag=APP_ENV
      # @defaultSensitive=false @defaultRequired=false
      # @generateTypes(lang=ts, path=env.d.ts)
      # ---

      # This is a config item comment block and may contain decorators which affect only the item
      # @required @type=enum(dev, test, staging, prod)
      APP_ENV=dev
    TEXT

    assert_match "dev", shell_output("#{bin}/varlock load 2>&1")
  end
end
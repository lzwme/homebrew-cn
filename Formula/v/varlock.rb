class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.21.1.tgz"
  sha256 "6eedadd26111c4e23aaa888dab2a7936dd3ce1389d4beaacb9daa4813cd4efca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb2f22f6e35ff44cfcd618f99722f7b31a1eecf16d1986689ef5acdc4cbfc0fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb2f22f6e35ff44cfcd618f99722f7b31a1eecf16d1986689ef5acdc4cbfc0fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb2f22f6e35ff44cfcd618f99722f7b31a1eecf16d1986689ef5acdc4cbfc0fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "783f37629b0fa992843c6ba1800ba4c4f810f0f887a9b89b5ffbd60d7f008f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ebb2650887ce7df64daefa65d5503b31235bf6be616a983fb3e73ad5b787a307"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    mac_bin = "VarlockEnclave.app/Contents/MacOS/varlock-local-encrypt"
    libexec.glob("lib/node_modules/varlock/node_modules/@varlock/native-helper-*").each do |dir|
      platform = dir.basename.to_s.delete_prefix("native-helper-")
      rm_r(dir) if OS.linux? && platform != "linux-#{arch}"
      deuniversalize_machos dir/mac_bin if OS.mac? && platform == "darwin"
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
class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.16.0.tgz"
  sha256 "346484dd30b73cac01455d5504d4336a04a37da94d543434028e8e263e76267e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61dfa952839f1fb61756700b9d59fb0f6ecbc4a25539d5974347e8b2a000415b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61dfa952839f1fb61756700b9d59fb0f6ecbc4a25539d5974347e8b2a000415b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61dfa952839f1fb61756700b9d59fb0f6ecbc4a25539d5974347e8b2a000415b"
    sha256 cellar: :any_skip_relocation, sonoma:        "49c4eb6cdce1ca8d6405d85919ea5f5b3b20a6870a144d16bc241f73534784e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8c1717a214e7cf8e14b90aa9d941b555dccd0eb89ba47a8289d7d4d05a26a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c773b7f35a395f051ac953e767da800b3ae0abd9e886d021be4b2d1052ee39ab"
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
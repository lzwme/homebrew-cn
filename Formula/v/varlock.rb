class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.12.0.tgz"
  sha256 "60d5f7a5a85bd61d31849dc6a1d291179801d5de06e8c1f42637dc0a6b1cd527"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaa321b76f6184bd4d2c945ee34d0c66e4ed6872aae8b17ce3449123369d107f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaa321b76f6184bd4d2c945ee34d0c66e4ed6872aae8b17ce3449123369d107f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaa321b76f6184bd4d2c945ee34d0c66e4ed6872aae8b17ce3449123369d107f"
    sha256 cellar: :any_skip_relocation, sonoma:        "08f38f3474c755d7cf4c27b9aacedbd31613a051d04f728bac047086f390540a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7f93dc180517c984ca4138b47cfd06b36571861e1ff7d25213325741b741f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d95a18a427227dbb999f9c10e1af4500b37e2a933de717025d5ec569721467a"
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
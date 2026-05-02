class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.0.0.tgz"
  sha256 "fa4320ae36b1afc750c9ab726263c03c569e6cca99fa59a1224bde6aa4e9241d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f88d9b380f1001441edf2e63ab333b04865591175799fe87e07fbff0a49fc01c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43d78d627c4e25b93b1f6037a53e31800c147584a10d76fada4aa13f533baddc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43d78d627c4e25b93b1f6037a53e31800c147584a10d76fada4aa13f533baddc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbd0f9e2fe6124513127f77627934871c02f5d17776eb86216a358190079d157"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fe2c4b2cac8f759c259c4bca4e16bcd60dd3bb7474e4c5d66c2db5f96e0fb18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e5c606b6ad1ea6dccf6ef8e2c0bca1d58550f0ffbcdc2240727514540120625"
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
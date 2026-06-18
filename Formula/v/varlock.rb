class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.7.0.tgz"
  sha256 "f064b172fcd5089aa4fb284e4c074727b59c30a4ad9a0ed08a65aa7f28ca0f73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "798a3bff22b51cc3df832b973f8beda13e1d5a1b99fbc302981dd7da32bdd180"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8251a0a54e3d266a506edfd2674e308dcaeffca9113743e3e71032742334134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8251a0a54e3d266a506edfd2674e308dcaeffca9113743e3e71032742334134"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce036eefb34ee4116359d51e4ab387055e6bf3ceafc51dbea6713ef55524d91b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b705defec44f93f29dbd0ecaaa60d473d5101c53508fc56e0ffddb345cb77648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9822e07d2d2704ed1479d2c5b4f10f093d06b9b1f0a97f99715057b7d30bbd2"
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
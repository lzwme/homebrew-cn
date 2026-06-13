class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.6.1.tgz"
  sha256 "adb7a5a24c97803f1a0a57e39e2aa783268351475adcb7ccb3a5e4d36063db66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af751ca0206228600d826a2fd096b701180ff173ff6cc58e819a6109f023ad82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "465175970dc1aaec143e15e12fed62059d288e1d53f5844092df9241b2c7d27c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "465175970dc1aaec143e15e12fed62059d288e1d53f5844092df9241b2c7d27c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7eab402b55091b7b74133e0020adfa4a5d360bd446320fcc102f1cc2f5dcce7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3d08d67c97f1913d72c45b99dffb13b1493d8353014db908fa449337d2f8231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb1fad69bd93a44b507264de6503db31c8744c1fd9db5d17477910494df8e36d"
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
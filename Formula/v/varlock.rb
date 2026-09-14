class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.19.0.tgz"
  sha256 "10cf9e4bd6b837798bd70f50e10fa3719a5acfe62d7f0af13c421ddeafaa2c5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b3661ba3407a6867bb8a064e372887a35309e724b53b15cb04f54f12b8b88f04"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b3661ba3407a6867bb8a064e372887a35309e724b53b15cb04f54f12b8b88f04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b3661ba3407a6867bb8a064e372887a35309e724b53b15cb04f54f12b8b88f04"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "86b010a74d31e435e2d1a71163a9e962e459af6d8f3042d0b2c37fafe3fc16f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3f64e08183a513d22d0e77b53cbed0493310b236b09a8fc9868d206caebe540e"
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
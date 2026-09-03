class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.18.0.tgz"
  sha256 "22297d7da0cce18a7bfb676c1d8d9cf2827ca3ee9354b852bbfe8a9f501b85c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdc8df4cecf38415482d46543544d8bc78d0b01c786f03cce9003876a64ab405"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdc8df4cecf38415482d46543544d8bc78d0b01c786f03cce9003876a64ab405"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdc8df4cecf38415482d46543544d8bc78d0b01c786f03cce9003876a64ab405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "960e61e71e811a70731e371a3f5d2da60d673c6a99be821578226dd859c7aa76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2fa87c297224df67949847349ffde234826464c48dd95c6cd9dd689f014212e"
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
class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.14.0.tgz"
  sha256 "34dc1af5521e21c76867d50aee7584675d764b6699722f61fac7dd0f5ae75e15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "121302633f78a309329ae34b1083925ad8c97debb0745d303e3fc2bebbfddec6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "121302633f78a309329ae34b1083925ad8c97debb0745d303e3fc2bebbfddec6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "121302633f78a309329ae34b1083925ad8c97debb0745d303e3fc2bebbfddec6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dc80326115007373be50ed07e1621baf8b1bf815fa169ca1b71ce066f435355"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f027b8b219952bcc2e3f684593f91c92398629feedc26158ae78a6eaef0dd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8759b8a659760027c9cf36aa5011403dc5b1d317a6ae9292f68b3a0f1ba40865"
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
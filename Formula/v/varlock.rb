class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.6.0.tgz"
  sha256 "67730672c55b523b53eaf08678d1d3e58aa36570666fde47b90da5b776636271"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d11427376e882f749d0dc0ecdc2bc5fd71eb113c5ac16128397685e4807efd3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b94d19511ec38b99e556f2994e6e37ace31fbcaada918c102aede140a5908fef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b94d19511ec38b99e556f2994e6e37ace31fbcaada918c102aede140a5908fef"
    sha256 cellar: :any_skip_relocation, sonoma:        "aae0373ad8ce9fa853851eaf72e291430fd4e07c3c0292700f52ced456be190c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "934a9c075f5605f390e2c6ac8f0cd0db9a0b05a193c4c571f848c15a3079c3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6872f3b22c5dfc9c9c5d95ece8d2c3c098263cf538f39df7e08be9b4bb4c7bd5"
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
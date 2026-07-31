class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.14.1.tgz"
  sha256 "cae9ca09430f9ad36fb497a843a77ba695eb20bf0b923fdcf8dfba4bb96682cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b4bf311c9d98d927964f5823bb4f4ffb3075365b010b1ce2e7c9aa70936e69d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b4bf311c9d98d927964f5823bb4f4ffb3075365b010b1ce2e7c9aa70936e69d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b4bf311c9d98d927964f5823bb4f4ffb3075365b010b1ce2e7c9aa70936e69d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff77145c7386dc4b4a435edeb342276573119b54f46908af95342d40a7141fb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "399b3970353d44e76c1e199e96e8620bd54a61596fd048079542357b58bfeb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "974a1b28d4e0b51ac125e85fe224b6dc3302daaabae30924fb4f39b6d4cd3f25"
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
class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.16.1.tgz"
  sha256 "f48e8a3b33985bb308625dcceb1bd6aa67fcbb7f317ad05e770198fc72dd17d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cc035f786605edd92a9a100d10b40235fa5c31eeaf14ed5c8a7be6bbfe62902"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cc035f786605edd92a9a100d10b40235fa5c31eeaf14ed5c8a7be6bbfe62902"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cc035f786605edd92a9a100d10b40235fa5c31eeaf14ed5c8a7be6bbfe62902"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbb7883ace427f2ceef7777166123ec3f9b3e22c7484150f924eaebc760ba939"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8398382664f26ef61c765cb1d5475a3d1acf739a9975d6efb7180a24e5524457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83f5ea5090b581d82dd9792c4a04bc06fa9faefa03a0e900eea07946950c9c96"
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
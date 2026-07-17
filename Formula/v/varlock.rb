class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.11.0.tgz"
  sha256 "9ef8f9f7d102d66db07719623b459aba356d94d742cb78d2d28f11c93049bc5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4a93ba7e95ad89ae40edae0e9d95c7b578a662e875f5a8dc330988bb3b688a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4a93ba7e95ad89ae40edae0e9d95c7b578a662e875f5a8dc330988bb3b688a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4a93ba7e95ad89ae40edae0e9d95c7b578a662e875f5a8dc330988bb3b688a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7578cd9645e67d4622c1d6d537d25baa6cc4ee0703567ecfc9e255b595d4e604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7fdcc62004d5329f313149ee7fd3bd7d8c0648d662c171b39bb173bcb0f4e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17918dcb63c050eee3afb27ae056f1c013bae802341d6c54f1433ece510df8f7"
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
class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.7.1.tgz"
  sha256 "7edd657250b39379d653cc2ac4437c2c6a7014aaab52d6fa8acc42a1f33818c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dc644fa013f377ef5fd99944d84c06ce3a8116da10f944daa5cd3f90be29f91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de006e2fdafe03acba5499b3ee2332b5176f4a1ea2e779fcc7c487fd643dd0eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de006e2fdafe03acba5499b3ee2332b5176f4a1ea2e779fcc7c487fd643dd0eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6a050cfc3ba059612b62a9451138a83e78fb889522f37c2187a2948e19a0dac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86d584969c021eee78ac82195fc019d262927d7045c12e807cf6410d235750b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72157cfcf1ca142b5a7de10457ce4ddd191035ead436b1d7c7a707812f3f6e7a"
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
class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.3.0.tgz"
  sha256 "1b6b0660adafa3d575944d0a605dcdd17da8b2d51434d54f3ee33d21929a167f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ccbc4ef06375d67ca8895ec1901f675867abcbddb452e26da596003349ed67e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dfa6198424e4c31d80a918854cf7c72ac2dbe41959a5b110fc6d9d24ae627d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dfa6198424e4c31d80a918854cf7c72ac2dbe41959a5b110fc6d9d24ae627d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "80ffcb37cbd567ca8d76fe9eb51a891156e48487c89fa005ff012ada4e790cef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "028c4e2cb2d916cc2019c3669a11aea3ae1ad1f67f2ad94b734d22c1139fe23a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "312423e884cc308a279fc174fd93c20dc3df625fa290011597372f432fd289ee"
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
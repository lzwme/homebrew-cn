class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.17.1.tgz"
  sha256 "1c3566c9e73d25734f3883e3b959b6a945345f2a841bfb8b76cb25dcfd9c6262"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f02697e1e0d414655eb3b5895ecb58a67148f21db3618145f16387030e3a1739"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f02697e1e0d414655eb3b5895ecb58a67148f21db3618145f16387030e3a1739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f02697e1e0d414655eb3b5895ecb58a67148f21db3618145f16387030e3a1739"
    sha256 cellar: :any_skip_relocation, sonoma:        "72575cdfa87bb3dad5dcb38b19b8d6f314b1c88ef392aff45416fc566088cb09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11ca5aab135ac60ffb0a11eae9e3a60f55cb55c27732bca78300f500d1585272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b83b7608ce74df851c8a395470b765307d007fff1b6af15ece83a83697d40e63"
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
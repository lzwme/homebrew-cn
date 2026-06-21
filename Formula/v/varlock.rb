class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.7.2.tgz"
  sha256 "536dc12bfa5d83ffd64de64008822e7065a9f562c93bc518177b37ce7fe42463"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "def9901a4c91c14beaa131ca69aea48089ecea0eb5b39bf5856097b7ca45e39c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ffd9283028ccac2b15c2a007fef171ca351463df71caed99097a1bb5e1815b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ffd9283028ccac2b15c2a007fef171ca351463df71caed99097a1bb5e1815b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d344730599e7c4066b2265be78dec43577e43179ea622c10cc5d63037c81dfc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d69b5e3c0fd16ca67cad1ba44eebb872060b7e7e78579b59c04c0d5ca9bf830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25b641d21b1e36cd0ec506909349dee0f2d930b8bd7b1f69ef06e9c2f9d40e2c"
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
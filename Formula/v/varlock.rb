class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.8.0.tgz"
  sha256 "a0e61e81b921220056a7b5a2b377df316db866709ee52b8962c0b56d12dff92b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b096e9edf2fb6af0e44a5ddd0c64ecef6297852a9344ad3a3a8022989ddb5bd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a83d207a3df27c82389e50a8ad6640b3c6c83e04f7743529fd2549c8cf620643"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a83d207a3df27c82389e50a8ad6640b3c6c83e04f7743529fd2549c8cf620643"
    sha256 cellar: :any_skip_relocation, sonoma:        "b04b7abe1775fb357322e7810f84ef97bb939f7dc7f7cfd5559edd25402d5936"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2b31096f9bf3bbd464818190c33ae112df94456fcbdc6f3b9ca9993d77696ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85f7784d7108dd776cd3f539ee09f8ef65d1f02e5784324e0c3ab84a11d36db0"
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
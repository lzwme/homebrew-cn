class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.21.0.tgz"
  sha256 "f5d714605beab2b230eeac0245bd7c33bc6ad6d30190f3ba49c7c43e80c5dd27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f4ce806301326a19df2bed4a498126d64d1d88a52d0497c833f1ff7e9297bdb4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f4ce806301326a19df2bed4a498126d64d1d88a52d0497c833f1ff7e9297bdb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f4ce806301326a19df2bed4a498126d64d1d88a52d0497c833f1ff7e9297bdb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "607216075aca784e0f043db2ffecb72c67639706936f9e68a56f1f8ca1240a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d24109891e2cfe7c16ffb1276be692765e1271664be9c2d5f48a1b761c9b6ef0"
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
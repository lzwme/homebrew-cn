class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.22.0.tgz"
  sha256 "ef183bab94107e36035f4a5d51aa04ecffe988644cded0d2a16e57a8a11fb1a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31ec4b1d6b4e255c3c1861950c0553e0e963c68abf17a9fc31b14708bcc4489e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31ec4b1d6b4e255c3c1861950c0553e0e963c68abf17a9fc31b14708bcc4489e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31ec4b1d6b4e255c3c1861950c0553e0e963c68abf17a9fc31b14708bcc4489e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "472cc89c33d5d6d21232797ad0ffcbb06763a3579662297ec2de0f70250c7a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "51a5ab96f6d51e8d03d410f95893bc79c18ce3020aa82cf2a5de9e226eb84c66"
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
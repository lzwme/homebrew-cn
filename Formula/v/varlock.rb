class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.4.0.tgz"
  sha256 "b270a78bceb428de007f0070c518f8137cafd32157fce8ad34d0a3f281de8449"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d32463c2de6fcad9318b2438b8665f4c79a52a23f66aa842671a9fa6c3cb5cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9080f4be9cc6f4d6079ccd17f7a70df6e5531d83016ce74d487c1a9a04a533f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9080f4be9cc6f4d6079ccd17f7a70df6e5531d83016ce74d487c1a9a04a533f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bcbd941761ca544e0185289c1317e617ca4ec553324fbd76b344359835c01f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4024767ae486afb96fb2e428f4f5c0f7b68f5b90df58a030dfdc64f69709a739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb6330759716e178f4099cb079a5fa6273e07b114f594caabe3b239cbd8e9cac"
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
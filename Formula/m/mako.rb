class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.8.tgz"
  sha256 "69c88452ef1b7f8e8069655e0659d4cef167ca49f459f3b7a89440a8fe1ead7b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bfc27d82dc1e5a8289505ee8b073588568f6a5e09f86ecfde50a19cec995ab5c"
    sha256 cellar: :any,                 arm64_sonoma:  "bfc27d82dc1e5a8289505ee8b073588568f6a5e09f86ecfde50a19cec995ab5c"
    sha256 cellar: :any,                 arm64_ventura: "bfc27d82dc1e5a8289505ee8b073588568f6a5e09f86ecfde50a19cec995ab5c"
    sha256 cellar: :any,                 sonoma:        "7d23703e7fb9ad527b476941048cdf522634cbf243c6dd00bfc746726346cde2"
    sha256 cellar: :any,                 ventura:       "7d23703e7fb9ad527b476941048cdf522634cbf243c6dd00bfc746726346cde2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4b676c176042ec0fbf772c8c01e6fd45aae9576962c9e6e4584dae861c1e6ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c87abf459a0eff0f4d72cd0e01667c7b9a0832b81169b41436aad93c3ffeb1cf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@umijs/mako/node_modules/nice-napi/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mako --version")

    output = shell_output("#{bin}/mako build 2>&1", 1)
    assert_match(/Load config failed/, output)
  end
end
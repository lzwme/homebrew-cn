require "language/node"

class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.7.6.tgz"
  sha256 "cb857d92a77eedf14df9592c127ed60968a89dfda0140acd81d6ddf69fd8c2dd"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "22e39fca18d00c0ac7b528ae86114a4594234db3d7298e51a221b45774664874"
    sha256                               arm64_ventura:  "7aff8d919b44a069da8da212861dfd36a5c9b34a3b0182305a08dbfbb7afd1c4"
    sha256                               arm64_monterey: "9f89fe9930656bf616563e6c10573070d8d53dcadc090840566a1e49ef18fc7c"
    sha256                               sonoma:         "21147cb68c6e87d0375bbdd6c61e69c50b3b0581e6bd38d79b6c4b502d724e2c"
    sha256                               ventura:        "3093e9429cb3e4a90bfe546280448f78c3cba1fbe0486831e7b634f6a53905a0"
    sha256                               monterey:       "d8b1e36292bda457d4f0728cdb9505e408dc3ace53ebbb22662d2acf067a0358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9523b921ed0bef220be22bb3abb234b06712dcc7569764cf70df8eb254b9da1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@umijs/mako/node_modules/nice-napi/prebuilds/*")
           .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mako --version")

    output = shell_output("#{bin}/mako build 2>&1", 1)
    assert_match(/Load config failed/, output)
  end
end
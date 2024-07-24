require "language/node"

class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.7.7.tgz"
  sha256 "53cbbbae4b956a7e26be2298363dfbe6ac12b1bc3371c73ae3b10de7c962a821"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "0b29341494485a93acd300f9eba720995df69aadb2130f666c40af2b1a26fd9f"
    sha256                               arm64_ventura:  "cf5244cae5db5745ee55abc21886739252d5de02f1bd3ce9d1809415fc1ec0c5"
    sha256                               arm64_monterey: "06f0558ac47203d1657bfad3c62fded4b14ec02a2526ee55254cef21dafb97f5"
    sha256                               sonoma:         "8f29b631013f18f9e4bd39ef5148f7ff5902de1e04ae66e93178d31114b1c052"
    sha256                               ventura:        "0023a84ce8b1b96e264c665fd15d6db62b9dff19d7c33ab8aac97c194985662a"
    sha256                               monterey:       "13e36133cc7d6ffdc62fdaebd65dc187275f835664130c8dda7297c647fb85af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de57e2f219d8fc0e0f52f9f6ec06724e2dc76933562767cd6b5261067b630781"
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
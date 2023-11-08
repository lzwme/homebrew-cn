require "language/node"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-7.0.1.tgz"
  sha256 "3b787a849f720244648d01e6f25120a92dd88c900c799b92bb4207ff311ab2ee"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "9685d5dcfd18fe7ecee18f565fafcae60b1d835db95ede5e44fe659a69c40700"
    sha256                               arm64_ventura:  "8185cb5be9847d02137f6512718f21524fe426817050c9f33e126cbadf9a0131"
    sha256                               arm64_monterey: "725678da423ad2b8cc9984b9fb0ed47113042691a9f7652bd581d107f8e9df2d"
    sha256                               sonoma:         "a991610d84c07d1a20606f32d675e7e2aea09257a32be65657f3e12bb120c6a1"
    sha256                               ventura:        "e32f498f9d2978fb388d0ffcbd30cf5d9b7ff076fdf4f65ae874c72dc8e0cc3d"
    sha256                               monterey:       "aaff211699ed5c4450441e689ca4fdb708f680b6ffc612de8e8dd5d911815426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59471671bdf88f35c866ec29649cd8660ccb7e80d661ef103e59ea8882ad459d"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/dicebear/node_modules"
    (node_modules/"@resvg/resvg-js-linux-x64-musl/resvgjs.linux-x64-musl.node").unlink if OS.linux?
  end

  test do
    output = shell_output("#{bin}/dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_predicate testpath/"avataaars-0.svg", :exist?

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")
  end
end
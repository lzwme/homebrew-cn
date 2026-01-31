class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.7.5.tgz"
  sha256 "3aa0ce1da68fc16d0f453991d44ddf05f57918ec2ec68a315cebf0c96b2ad2fc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6234af095c493f8f2a118e5e4e3025c19a5b66c8d9000ee593a6531d18e43cab"
    sha256 cellar: :any,                 arm64_sequoia: "76d6b6eb995d80f1f098a9eb660d933676ad0ff149d5324bc0bd2f4aa15ec500"
    sha256 cellar: :any,                 arm64_sonoma:  "76d6b6eb995d80f1f098a9eb660d933676ad0ff149d5324bc0bd2f4aa15ec500"
    sha256 cellar: :any,                 sonoma:        "efb191c9347b1196532b45ef2eed4348a1846e0741359b9f118962ce1f001c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e955758598ab3a89d3383642d63e872c7b14281149fda3cb18531fde95f67f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45d603f86036837a24b19ff57b4817799f8b69e0a011aa426046602c37736504"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/dtsroll/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtsroll --version")

    (testpath/"dts.d.ts").write "export type Foo = string;"

    assert_match "Entry points\n → dts.d.ts", shell_output("#{bin}/dtsroll dts.d.ts")
  end
end
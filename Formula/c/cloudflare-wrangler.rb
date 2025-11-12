class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.47.0.tgz"
  sha256 "96ed03223b83c2b778383277c31444efdaa40ad71cec4d7faa3671f7ae97ebcb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49987ef3721c9fdf58d1434042c398d228657ecfa83732d9c0b43cb041497510"
    sha256 cellar: :any,                 arm64_sequoia: "02e6904e45b027dd295633c411ebd66c7e4e3ea71fa28a683cd322522055c90e"
    sha256 cellar: :any,                 arm64_sonoma:  "02e6904e45b027dd295633c411ebd66c7e4e3ea71fa28a683cd322522055c90e"
    sha256 cellar: :any,                 sonoma:        "141b0d6f3bb96d22d4469a33dc73b8e0b634aa491ec7a613c40735e4b2fea108"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1986c3429197b9e37baa6130bf73f1e9a237a79c8cdac2b43e775d2b1dc11cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e986e1437cf3b2f8b5af1684746691f72eb41df7c3befde54efd8acb9e607d15"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
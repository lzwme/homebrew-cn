class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.20.13.tgz"
  sha256 "b19ae4db014600b8a8974a8ce97649dc8495cd84d8219438ecb092f2690f5ee7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a93013b97273ee2c6e269497dcd4a14db7dff4775af49f821550e6f71709685"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a93013b97273ee2c6e269497dcd4a14db7dff4775af49f821550e6f71709685"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a93013b97273ee2c6e269497dcd4a14db7dff4775af49f821550e6f71709685"
    sha256 cellar: :any_skip_relocation, sonoma:        "a126494c381e2884a71f644298238de2d78b6ccd9aa3bae5af973881da05f2c8"
    sha256 cellar: :any_skip_relocation, ventura:       "a126494c381e2884a71f644298238de2d78b6ccd9aa3bae5af973881da05f2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39f9e9f30163d1ceefac7fd468114b61822e911fe5570037cf9f41b210a10e72"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_predicate testpath/"storage/key_value_stores/default/INPUT.json", :exist?

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end
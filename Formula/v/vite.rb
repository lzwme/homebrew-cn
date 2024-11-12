class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.11.tgz"
  sha256 "e970ff612f455681c5e56ea699ec0828c68ffa89e05aa135ae4d7d0326b5198a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "757ea2dea503f386e5c741d5b6ba461c7a7b41b72bfdf7b96bb252d7a0558409"
    sha256 cellar: :any,                 arm64_sonoma:  "757ea2dea503f386e5c741d5b6ba461c7a7b41b72bfdf7b96bb252d7a0558409"
    sha256 cellar: :any,                 arm64_ventura: "757ea2dea503f386e5c741d5b6ba461c7a7b41b72bfdf7b96bb252d7a0558409"
    sha256 cellar: :any,                 sonoma:        "f852306eb97051070ae57ada0c3a65887919e6408a621a0780b50475ac412e27"
    sha256 cellar: :any,                 ventura:       "f852306eb97051070ae57ada0c3a65887919e6408a621a0780b50475ac412e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36af755c08a186ea8c493dddda5009f3988bdc470c60b765cd29fa49bbfcbe2c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
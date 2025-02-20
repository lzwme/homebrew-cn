class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.1.1.tgz"
  sha256 "e9e0e0124d0edfe02663eab0fcc5d160079ca24a131df89e5bffecb90eaaba65"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5cdae305395b5a124ec31d555c3fcfba32b76182fc4908237294063c21ebc5ca"
    sha256 cellar: :any,                 arm64_sonoma:  "5cdae305395b5a124ec31d555c3fcfba32b76182fc4908237294063c21ebc5ca"
    sha256 cellar: :any,                 arm64_ventura: "5cdae305395b5a124ec31d555c3fcfba32b76182fc4908237294063c21ebc5ca"
    sha256 cellar: :any,                 sonoma:        "3b83d74be1b6d07f7d2a26c7fd62a1841431fbfab0d219849ac8b31deab84a64"
    sha256 cellar: :any,                 ventura:       "3b83d74be1b6d07f7d2a26c7fd62a1841431fbfab0d219849ac8b31deab84a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d9a39cdba527a5475fd5dfe2d1b9dd63f172eb4bc78ecc106e0d5e999c533cb"
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
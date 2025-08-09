class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.1.1.tgz"
  sha256 "f1bd1f84e6a50323bcf2de63d43d55b3f2349867e66d28ecd498f568faade845"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "99aa9373f04dd24cd290981026fde83c78654e9b883bc5d3756359a44a586721"
    sha256 cellar: :any,                 arm64_sonoma:  "99aa9373f04dd24cd290981026fde83c78654e9b883bc5d3756359a44a586721"
    sha256 cellar: :any,                 arm64_ventura: "99aa9373f04dd24cd290981026fde83c78654e9b883bc5d3756359a44a586721"
    sha256 cellar: :any,                 sonoma:        "7bf11bf7c00def9e4e63bff3cecccdc9603d79520edff7590b334cd45b1fc02f"
    sha256 cellar: :any,                 ventura:       "7bf11bf7c00def9e4e63bff3cecccdc9603d79520edff7590b334cd45b1fc02f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ca4d7a8ca80d0d6fdabb627200e866d7ed894cc72331f52abd49c6a51a26ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "762ebae35cd620acd69243366de60d7b1b587012c738bd5dabb5d3578f1dd912"
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
class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.0.3.tgz"
  sha256 "afaf01ea5a12d1eacd3dd4f0268a445be70c5648b86b31e27b551f5d67df668b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "255e970f14f4957c62de997d59919160b37bedbd7d37144f76a0cc552b1436cb"
    sha256 cellar: :any,                 arm64_sonoma:  "255e970f14f4957c62de997d59919160b37bedbd7d37144f76a0cc552b1436cb"
    sha256 cellar: :any,                 arm64_ventura: "255e970f14f4957c62de997d59919160b37bedbd7d37144f76a0cc552b1436cb"
    sha256 cellar: :any,                 sonoma:        "c488f3df0eeb44da2ae6e2bdbc48442462ca2941d418db2a40e41893b8eeaa1a"
    sha256 cellar: :any,                 ventura:       "c488f3df0eeb44da2ae6e2bdbc48442462ca2941d418db2a40e41893b8eeaa1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebf6c59e9a415635a6476ea44f2d8ed8633822e64ff90af3f14341979c2ca4bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d5e057532ba1d79fab4a4638828ab6469891cf68c7177d5e1e817d9037f8b0"
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
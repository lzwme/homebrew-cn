class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.4.3.tgz"
  sha256 "e54bf23974ca99c3a02584b404f2f64ff7e6e2593998cfc5dec219d520238627"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b5fcf28b794a0f73209b7896a35dc536a08c63e663b98960ee4ca5c91074fcf"
    sha256 cellar: :any,                 arm64_sonoma:  "7b5fcf28b794a0f73209b7896a35dc536a08c63e663b98960ee4ca5c91074fcf"
    sha256 cellar: :any,                 arm64_ventura: "7b5fcf28b794a0f73209b7896a35dc536a08c63e663b98960ee4ca5c91074fcf"
    sha256 cellar: :any,                 sonoma:        "19bc8c5b75aef4744f8e5d2be68dae57119db5227f0d8e3c11a44c553310fd87"
    sha256 cellar: :any,                 ventura:       "19bc8c5b75aef4744f8e5d2be68dae57119db5227f0d8e3c11a44c553310fd87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "449e6a78bcf6a92347eff7d53c5565d86891673ab913cc86f2682057a0304e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e6621c8077481345e4ed2a55108c3b297fe2076de0682ce82f86c8722562e71"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end
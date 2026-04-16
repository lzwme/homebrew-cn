class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-3.9.0.tgz"
  sha256 "f701aff4e850003e3bf551688a5945396f6d2d2a1af73cab23dbfb020ed87211"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12713cbf61b2cba30db9baefac452bfb06b7dd405a4863e2ae5d22258e92adfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12713cbf61b2cba30db9baefac452bfb06b7dd405a4863e2ae5d22258e92adfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12713cbf61b2cba30db9baefac452bfb06b7dd405a4863e2ae5d22258e92adfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "74298e97913b257585760cd9651928c545a27d399b4c2ca5eec6649e06366d14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "858aad69d7098d0f976e5668a0b23b10673e6e5da079c5cf47d45cebafb66045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07bd900f0a624145a0dc01c7aabf16ef5889152bd609bd7691e0380a796ad494"
  end

  depends_on "pkgconf" => :build
  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/vsce verify-pat 2>&1", 1)
    assert_match "Extension manifest not found:", error
  end
end
class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.0.2.tgz"
  sha256 "9ff3abfd5496553e76c4c27153c8102a20fd8a176f3aae8681ceecc3b5da1380"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "78fa0d85e342485c27a52ca94236655bb62094d878a2683550c35caf8e376062"
    sha256 cellar: :any,                 arm64_sonoma:  "78fa0d85e342485c27a52ca94236655bb62094d878a2683550c35caf8e376062"
    sha256 cellar: :any,                 arm64_ventura: "78fa0d85e342485c27a52ca94236655bb62094d878a2683550c35caf8e376062"
    sha256 cellar: :any,                 sonoma:        "3a2de29858c696c24443c47344f0929c1c4b7020f4bb39139e1d540b066a83c7"
    sha256 cellar: :any,                 ventura:       "3a2de29858c696c24443c47344f0929c1c4b7020f4bb39139e1d540b066a83c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "216c8d45a11ec103ca8e5c76d8a7dc3a007bb56a1e54e6fbc0f696f39e664338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c2c81eca858fb7c13fedf8dcd1e7be2a2358c46375173ffd1ae16997777a41a"
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
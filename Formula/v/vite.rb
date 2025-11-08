class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.2.2.tgz"
  sha256 "d113824a34e9c65e4197df82e4856db4ce94028b972f7a85a3b756ca87d6a63d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70a68f01105dab32d5ea0b98a09e184c71b1510c239e50a34b166667aeac6ad3"
    sha256 cellar: :any,                 arm64_sequoia: "66e33b57e187a050c1ec7b264fcfd5ca3a8dc2d9774e2c7e04996f33525f34b9"
    sha256 cellar: :any,                 arm64_sonoma:  "66e33b57e187a050c1ec7b264fcfd5ca3a8dc2d9774e2c7e04996f33525f34b9"
    sha256 cellar: :any,                 sonoma:        "37b94265c00a778eb3850837bb05e6e7e330435c4a40eded08aaa1aee5c7b3a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b96efed8add8490d257de0ed1ac596d983a574fc40220d080c24e3577f3afc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04fa000ad3c3f08527a309535db9e91062549f4f71f2c7e8b63305e94afd3bf2"
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
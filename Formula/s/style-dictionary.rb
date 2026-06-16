class StyleDictionary < Formula
  desc "Build system for creating cross-platform styles"
  homepage "https://styledictionary.com"
  url "https://registry.npmjs.org/style-dictionary/-/style-dictionary-5.4.4.tgz"
  sha256 "dd51cb82b1511724c4e2a73cf99c0b35bb7cc46adf6161b790f582b487a74539"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b355c51a0c5ee653f0e8c4aeb8f92f053b4f4c1195b8b4ab8540f0c81b60dc2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Build an `:all` bottle by removing example files
    examples = libexec/"lib/node_modules/style-dictionary/examples"
    rm %w[
      advanced/create-react-native-app/android/app/proguard-rules.pro
      complete/android/demo/proguard-rules.pro
    ].map { |file| examples/file }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/style-dictionary --version")

    output = shell_output("#{bin}/style-dictionary init basic")
    assert_match "Source style dictionary starter files created!", output
    assert_path_exists testpath/"config.json"

    output = shell_output("#{bin}/style-dictionary build")
    assert_match "✔︎ build/css/_variables.css", output
    assert_path_exists testpath/"build/css/_variables.css"
  end
end
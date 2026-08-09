class StyleDictionary < Formula
  desc "Build system for creating cross-platform styles"
  homepage "https://styledictionary.com"
  url "https://registry.npmjs.org/style-dictionary/-/style-dictionary-5.5.1.tgz"
  sha256 "90a46f042a1b24301037b31667d0652841bda3bc29c31994339f1e59270169c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e852bb062a8288e2c4742ffaf1f14cab4e43dfda876dc4b3b14299e163e70c74"
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
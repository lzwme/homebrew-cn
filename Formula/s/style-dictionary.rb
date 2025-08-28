class StyleDictionary < Formula
  desc "Build system for creating cross-platform styles"
  homepage "https://github.com/style-dictionary/style-dictionary"
  url "https://registry.npmjs.org/style-dictionary/-/style-dictionary-5.0.3.tgz"
  sha256 "46a5e6ecd3048cb46e119ba7bf278cb1b7845785c60d0e8d8e782c8436fee71a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4bf12e677f42d2901db0b0e4c5d13742ff8694f526f7b2a9fc566eb6b7aa3a4c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
    assert_match "Token collisions detected", output
  end
end
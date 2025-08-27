class StyleDictionary < Formula
  desc "Build system for creating cross-platform styles"
  homepage "https://github.com/style-dictionary/style-dictionary"
  url "https://registry.npmjs.org/style-dictionary/-/style-dictionary-5.0.2.tgz"
  sha256 "bcd65cc6316f3090ca35e4f2627af850ba94bd8fabf0cb023a6b8d90af074fdd"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b67f0f14ae2223cae85033ae7238cef09de8f8aac5fdc0c3e6a9efb4899c949c"
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
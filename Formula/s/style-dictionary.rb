class StyleDictionary < Formula
  desc "Build system for creating cross-platform styles"
  homepage "https://styledictionary.com"
  url "https://registry.npmjs.org/style-dictionary/-/style-dictionary-5.5.5.tgz"
  sha256 "844c4dba2198f43f296f4490c65680c9f80b670e41ecc2a7068b6e2fdca52faa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "85bc50f65c26e4573bb39f4c8957a82a38290986753b2afa6001f218eeb344d1"
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
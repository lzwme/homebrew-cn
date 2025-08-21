class StyleDictionary < Formula
  desc "Build system for creating cross-platform styles"
  homepage "https://github.com/style-dictionary/style-dictionary"
  url "https://registry.npmjs.org/style-dictionary/-/style-dictionary-5.0.2.tgz"
  sha256 "bcd65cc6316f3090ca35e4f2627af850ba94bd8fabf0cb023a6b8d90af074fdd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d6183211d5e15fd0da57fed80ca4ca87fe1db93d146ea45c73977dd528eee88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d6183211d5e15fd0da57fed80ca4ca87fe1db93d146ea45c73977dd528eee88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d6183211d5e15fd0da57fed80ca4ca87fe1db93d146ea45c73977dd528eee88"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cfa15cb60c1a721a83a01c5348752f9555c1d650f380d880ef994147ebef96b"
    sha256 cellar: :any_skip_relocation, ventura:       "8cfa15cb60c1a721a83a01c5348752f9555c1d650f380d880ef994147ebef96b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d6183211d5e15fd0da57fed80ca4ca87fe1db93d146ea45c73977dd528eee88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d6183211d5e15fd0da57fed80ca4ca87fe1db93d146ea45c73977dd528eee88"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
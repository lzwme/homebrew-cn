class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-4.17.2.tgz"
  sha256 "28a0ebae7bcf5b094b44ae00bdce8a7de43f0098fff976a889d755f775270f12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a19f272bbbe8a58d877cad0cdcde5b69286afe6ee09736c170dac0552c07f3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c12b9304ac7267df364852ccd4c17e12c7c8aa3daf33eced272602a2c7c81fa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c12b9304ac7267df364852ccd4c17e12c7c8aa3daf33eced272602a2c7c81fa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3fe4944fa20e2ac0533b589862054b5ffc2d6d887eae78a6b417825649faac7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2898cbe5afe51fe4741b51120b846dcbc8cdc68c119d22c72b6d6066b2e031b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2898cbe5afe51fe4741b51120b846dcbc8cdc68c119d22c72b6d6066b2e031b1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/mjml/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    (testpath/"input.mjml").write <<~EOS
      <mjml>
        <mj-body>
          <mj-section>
            <mj-column>
              <mj-text>
                Hello Homebrew!
              </mj-text>
            </mj-column>
          </mj-section>
        </mj-body>
      </mjml>
    EOS
    compiled_html = shell_output("#{bin}/mjml input.mjml")
    assert_match "Hello Homebrew!", compiled_html

    assert_equal <<~EOS, shell_output("#{bin}/mjml --version")
      mjml-core: #{version}
      mjml-cli: #{version}
    EOS
  end
end
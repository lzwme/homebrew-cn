require "language/node"

class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-4.15.2.tgz"
  sha256 "47ced5d72f001745b0edadd7075e7c8b1bac3fe4f0c479a0898ee9eb5158f0d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a82ec310d5b2d1f9e5ea63bf5cc41d941feddceb8f589599adacf06fd1df0d5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a82ec310d5b2d1f9e5ea63bf5cc41d941feddceb8f589599adacf06fd1df0d5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a82ec310d5b2d1f9e5ea63bf5cc41d941feddceb8f589599adacf06fd1df0d5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "17198d650af949695d0183019e9b60a665d9855f0c8c9fcf164ab87f132e6a15"
    sha256 cellar: :any_skip_relocation, ventura:        "17198d650af949695d0183019e9b60a665d9855f0c8c9fcf164ab87f132e6a15"
    sha256 cellar: :any_skip_relocation, monterey:       "17198d650af949695d0183019e9b60a665d9855f0c8c9fcf164ab87f132e6a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e0ebb39ede5b5dcf799fe2d8a67156ff5a1a678ff0ccabf7254733c05a96fd7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos libexec/"lib/node_modules/mjml/node_modules/fsevents/fsevents.node"
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
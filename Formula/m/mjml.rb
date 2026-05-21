class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-5.2.2.tgz"
  sha256 "f59d63fc921f11bf64941aef67225708162b0012cda36a4273f80ec7d7ad4514"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e3f21cbf9b4c1222081c6e2d5560bb8c9cdec32b7b6a38814908807e7f98e05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac25931ac32af203b7bc370932e829c2190763a58a1fc9e595407b7d85678652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac25931ac32af203b7bc370932e829c2190763a58a1fc9e595407b7d85678652"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5e1180502aaf7acddafc0c1b99efb489e1e4760f045545d53389eab583a0773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9483fcbdf9c823d7df38007564cf43fdd9760194896dc8c7d0735353cc15acc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9483fcbdf9c823d7df38007564cf43fdd9760194896dc8c7d0735353cc15acc9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
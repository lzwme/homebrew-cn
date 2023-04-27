require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://ghproxy.com/https://github.com/apidoc/apidoc/archive/1.0.1.tar.gz"
  sha256 "70508f5bba19940b2e1f0f71186e9f1abe2b5d08f6569fa8116fb21b92e084e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dceaf411ae051794c9e727f5a554cc8d3a5632b5beb846722cd0101a5e6d0e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dceaf411ae051794c9e727f5a554cc8d3a5632b5beb846722cd0101a5e6d0e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dceaf411ae051794c9e727f5a554cc8d3a5632b5beb846722cd0101a5e6d0e5"
    sha256 cellar: :any_skip_relocation, ventura:        "954c08c8c81e294270ea164aa947092633da88c712f230e739bf61dfdbc3e81b"
    sha256 cellar: :any_skip_relocation, monterey:       "954c08c8c81e294270ea164aa947092633da88c712f230e739bf61dfdbc3e81b"
    sha256 cellar: :any_skip_relocation, big_sur:        "954c08c8c81e294270ea164aa947092633da88c712f230e739bf61dfdbc3e81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8656188e99c7f8868acbb63abcdc58fb8f9a4a854c4dd10e6752bf7271a40d9"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Extract native slices from universal binaries
    deuniversalize_machos
  end

  test do
    (testpath/"api.go").write <<~EOS
      /**
       * @api {get} /user/:id Request User information
       * @apiVersion #{version}
       * @apiName GetUser
       * @apiGroup User
       *
       * @apiParam {Number} id User's unique ID.
       *
       * @apiSuccess {String} firstname Firstname of the User.
       * @apiSuccess {String} lastname  Lastname of the User.
       */
    EOS
    (testpath/"apidoc.json").write <<~EOS
      {
        "name": "brew test example",
        "version": "#{version}",
        "description": "A basic apiDoc example"
      }
    EOS
    system bin/"apidoc", "-i", ".", "-o", "out"
    assert_predicate testpath/"out/assets/main.bundle.js", :exist?
  end
end
require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://ghproxy.com/https://github.com/apidoc/apidoc/archive/1.0.2.tar.gz"
  sha256 "4e0f063e293ff4f24b785e0a6a1f1833f46140dd98391cee887b427aa37f37ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bca0aae352d4e22f865a9b7c09f11d42af01311b85e41569eebed4d0908e616d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bca0aae352d4e22f865a9b7c09f11d42af01311b85e41569eebed4d0908e616d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bca0aae352d4e22f865a9b7c09f11d42af01311b85e41569eebed4d0908e616d"
    sha256 cellar: :any_skip_relocation, ventura:        "5c181515ea9dcfbab3286ff2721d6068fb895ecfadcd87e64a1dc7fd025374d8"
    sha256 cellar: :any_skip_relocation, monterey:       "5c181515ea9dcfbab3286ff2721d6068fb895ecfadcd87e64a1dc7fd025374d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c181515ea9dcfbab3286ff2721d6068fb895ecfadcd87e64a1dc7fd025374d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43212918028806c4271f35452853814d2d56a05af4fda8f9ee550575da70036c"
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
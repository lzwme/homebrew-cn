require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://ghproxy.com/https://github.com/apidoc/apidoc/archive/1.0.3.tar.gz"
  sha256 "822756eacfd7c12f3221bf8c0b85b8c1d30b8bc714e6f8c7da3de60b219c6d44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e70878b579cfdff918e4e7919e848f0ce3151de950d2d12f0a9009afb42c70d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e70878b579cfdff918e4e7919e848f0ce3151de950d2d12f0a9009afb42c70d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e70878b579cfdff918e4e7919e848f0ce3151de950d2d12f0a9009afb42c70d"
    sha256 cellar: :any_skip_relocation, ventura:        "88ae5aa1b0384947a5d1a2aec678257955f6ad848430b1d100675e68f3ec8b66"
    sha256 cellar: :any_skip_relocation, monterey:       "88ae5aa1b0384947a5d1a2aec678257955f6ad848430b1d100675e68f3ec8b66"
    sha256 cellar: :any_skip_relocation, big_sur:        "88ae5aa1b0384947a5d1a2aec678257955f6ad848430b1d100675e68f3ec8b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dd6daae879bb94d8c8df53de6f04361d4926370c3a361f0f6d9eee99836dbe6"
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
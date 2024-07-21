require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.33.2.tgz"
  sha256 "d28342658a903da5abf4d4335e8b8bd771d124c6218dfc857795948ac2dbf329"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76a788ec69519f2197f972e8c9b28924e7c3d6d42f12404b2d40afc1d54d443b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76a788ec69519f2197f972e8c9b28924e7c3d6d42f12404b2d40afc1d54d443b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76a788ec69519f2197f972e8c9b28924e7c3d6d42f12404b2d40afc1d54d443b"
    sha256 cellar: :any_skip_relocation, sonoma:         "76a788ec69519f2197f972e8c9b28924e7c3d6d42f12404b2d40afc1d54d443b"
    sha256 cellar: :any_skip_relocation, ventura:        "76a788ec69519f2197f972e8c9b28924e7c3d6d42f12404b2d40afc1d54d443b"
    sha256 cellar: :any_skip_relocation, monterey:       "76a788ec69519f2197f972e8c9b28924e7c3d6d42f12404b2d40afc1d54d443b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbb3a29457ce1534b51fa7e3b044633bce328c49bf08422708fe7a5076cd6dfa"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end
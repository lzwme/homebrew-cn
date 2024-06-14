require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.30.5.tgz"
  sha256 "2e37bc28724a88b27f840dbffbd665ea8dcf40a86b6a229183bc483bf64e7d21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31dde8e270fa27466332c7fbf0f3f2674cedafe82b472a55eeed90dbaa460332"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31dde8e270fa27466332c7fbf0f3f2674cedafe82b472a55eeed90dbaa460332"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31dde8e270fa27466332c7fbf0f3f2674cedafe82b472a55eeed90dbaa460332"
    sha256 cellar: :any_skip_relocation, sonoma:         "31dde8e270fa27466332c7fbf0f3f2674cedafe82b472a55eeed90dbaa460332"
    sha256 cellar: :any_skip_relocation, ventura:        "31dde8e270fa27466332c7fbf0f3f2674cedafe82b472a55eeed90dbaa460332"
    sha256 cellar: :any_skip_relocation, monterey:       "31dde8e270fa27466332c7fbf0f3f2674cedafe82b472a55eeed90dbaa460332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab4302e5cdfc4db5e7b89098fce4d3b619bb0b8845f10cb06368d6abb0b88582"
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
require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.19.0.tgz"
  sha256 "cdd75637f3ccba1d80cca04d1acd2ced8ff46ed95a94fb4731aa866bd1725ea0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a812d481a6ece885a2e84a51c0f1b43bb8e695cf0894106246a8ab173007a79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a812d481a6ece885a2e84a51c0f1b43bb8e695cf0894106246a8ab173007a79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a812d481a6ece885a2e84a51c0f1b43bb8e695cf0894106246a8ab173007a79"
    sha256 cellar: :any_skip_relocation, ventura:        "5dbc37763382b9b15b7c3b4c2464289230b3673b9d6f39129945abc295526843"
    sha256 cellar: :any_skip_relocation, monterey:       "5dbc37763382b9b15b7c3b4c2464289230b3673b9d6f39129945abc295526843"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dbc37763382b9b15b7c3b4c2464289230b3673b9d6f39129945abc295526843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64d0b924ab8570f762b0d329cb47c5fb6b33d3dd2d435b45e26f7ce48f548c90"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed,", output)
  end
end
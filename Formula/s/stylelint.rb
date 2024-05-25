require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.6.0.tgz"
  sha256 "1a08a434cfd9609a58954757226a01ecb09b342b1d13ad21f3363a46e071a8d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db0f2411a1923afa6df303ca83dee0b989b4364fabc74a2f62122625fd02cda9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb08f97603eac8636599616e4fe0a1f8e759b0f773ecb13578cfc371f9dfa4ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e510342093b1b59c90ad7425780d35c1e155e9c6407e06829b3ca9fecc6adc67"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae41929bb0339c1667ea05b528545c620cc44f45d180531a86953b2a3e973158"
    sha256 cellar: :any_skip_relocation, ventura:        "b3eab309753b5879d01e750041dfb7112deecf1f10cc461f988e4a3ee7477b2a"
    sha256 cellar: :any_skip_relocation, monterey:       "7ed669058f6e7a6fbd02f5bfe7aec50052bb7e87fb9f1e7e9c030302084b3762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac9c92501a2a7ba1f9c44a9a95b503fb1171237d63e7b285f43b070e7bd43550"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~EOS
      {
        "rules": {
          "block-no-empty": true
        }
      }
    EOS

    (testpath/"test.css").write <<~EOS
      a {
      }
    EOS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
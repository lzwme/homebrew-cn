require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.0.2.tgz"
  sha256 "7e37b3ca89dfef5618a29402e462cfe5582caebc4bfe98e74e2bb423620c509c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdcd5032a08712b7fc16a809edf5f8cf571282d134c1b014b2ab96db3572158b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdcd5032a08712b7fc16a809edf5f8cf571282d134c1b014b2ab96db3572158b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdcd5032a08712b7fc16a809edf5f8cf571282d134c1b014b2ab96db3572158b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b1083341050397fac97b1aa135f1946c162354fd7b62e9849f01e230e51d717"
    sha256 cellar: :any_skip_relocation, ventura:        "7b1083341050397fac97b1aa135f1946c162354fd7b62e9849f01e230e51d717"
    sha256 cellar: :any_skip_relocation, monterey:       "7b1083341050397fac97b1aa135f1946c162354fd7b62e9849f01e230e51d717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdcd5032a08712b7fc16a809edf5f8cf571282d134c1b014b2ab96db3572158b"
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
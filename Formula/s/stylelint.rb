require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.8.0.tgz"
  sha256 "b59aaf49439f60a43aff7b883f07142d240227bef89135593db04b908d6e196b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "643bff74cbff9efe1d83ec7e59005cb91c552eec59c69032dbf8a66fcad86701"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "643bff74cbff9efe1d83ec7e59005cb91c552eec59c69032dbf8a66fcad86701"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "643bff74cbff9efe1d83ec7e59005cb91c552eec59c69032dbf8a66fcad86701"
    sha256 cellar: :any_skip_relocation, sonoma:         "87ff84ab0c176e6cc68da1b9c759b2f1125aee5cc1f3722eb079c91f881d1c21"
    sha256 cellar: :any_skip_relocation, ventura:        "87ff84ab0c176e6cc68da1b9c759b2f1125aee5cc1f3722eb079c91f881d1c21"
    sha256 cellar: :any_skip_relocation, monterey:       "87ff84ab0c176e6cc68da1b9c759b2f1125aee5cc1f3722eb079c91f881d1c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06f57f471c2ebd136383a55c03ed1af75068339220bf9380c01030db45bb7f17"
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
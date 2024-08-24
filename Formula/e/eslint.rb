class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.9.1.tgz"
  sha256 "9330e387bf443fa545124abff4c746b10a88fc6f3236606b7f12cc2133256095"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac20ca8ba59d55e7f6d4b5b78cf77b6308b0395c93564a72f4d6a4377128f79f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac20ca8ba59d55e7f6d4b5b78cf77b6308b0395c93564a72f4d6a4377128f79f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac20ca8ba59d55e7f6d4b5b78cf77b6308b0395c93564a72f4d6a4377128f79f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e42d574f3a5aa14763a611e5f6a45a7b70876ec84cf9fdcc578ae19e4131ef4d"
    sha256 cellar: :any_skip_relocation, ventura:        "e42d574f3a5aa14763a611e5f6a45a7b70876ec84cf9fdcc578ae19e4131ef4d"
    sha256 cellar: :any_skip_relocation, monterey:       "e42d574f3a5aa14763a611e5f6a45a7b70876ec84cf9fdcc578ae19e4131ef4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac20ca8ba59d55e7f6d4b5b78cf77b6308b0395c93564a72f4d6a4377128f79f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://eslint.org/docs/latest/use/configure/configuration-files#configuration-file
    (testpath/"eslint.config.js").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")

    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https:eslint.org"
  url "https:registry.npmjs.orgeslint-eslint-9.30.0.tgz"
  sha256 "551a6553754de83ca3550853baa5cff163b0a86f39d83f21719ee39718f8c665"
  license "MIT"
  head "https:github.comeslinteslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d1e17850d399da2ed1fb1a613d455f339e76c95728232a893bbd7280c292602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d1e17850d399da2ed1fb1a613d455f339e76c95728232a893bbd7280c292602"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d1e17850d399da2ed1fb1a613d455f339e76c95728232a893bbd7280c292602"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b25b83cfe66de8d2207b01f0356f66b346a49c9515026cda47f2bfbc2deeb60"
    sha256 cellar: :any_skip_relocation, ventura:       "1b25b83cfe66de8d2207b01f0356f66b346a49c9515026cda47f2bfbc2deeb60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d1e17850d399da2ed1fb1a613d455f339e76c95728232a893bbd7280c292602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d1e17850d399da2ed1fb1a613d455f339e76c95728232a893bbd7280c292602"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    # https:eslint.orgdocslatestuseconfigureconfiguration-files#configuration-file
    (testpath"eslint.config.js").write("{}") # minimal config
    (testpath"syntax-error.js").write("{}}")

    # https:eslint.orgdocsuser-guidecommand-line-interface#exit-codes
    output = shell_output("#{bin}eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
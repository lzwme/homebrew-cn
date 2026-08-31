class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.18.0.tgz"
  sha256 "d05b8456049e868eda87fcb6272a002f28c46a23cd9aa312401e11cdaf8b6703"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7eb027f5c8eb497a88cb0286d0695e701139cdeed5be57325ab609df6b53a835"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eb027f5c8eb497a88cb0286d0695e701139cdeed5be57325ab609df6b53a835"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eb027f5c8eb497a88cb0286d0695e701139cdeed5be57325ab609df6b53a835"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "301e43a912aeeabd4d84b6a05eadf5ffac5860d73aec088dfe9fc47ccd07806a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "301e43a912aeeabd4d84b6a05eadf5ffac5860d73aec088dfe9fc47ccd07806a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
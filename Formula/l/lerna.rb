class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-9.0.5.tgz"
  sha256 "7a58e71b192c17ef0ef7281e6f2ee7f0c640ce1dfb2a623eb8fddd312ea547df"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f744c2994e89783070ad404175ca54099de35628d43c0b80a1ff045c2e3195d"
    sha256 cellar: :any,                 arm64_sequoia: "3fc6fc394b6440a59b910c982b1d2f329eb49f83287a60fcb0447b9e1364d919"
    sha256 cellar: :any,                 arm64_sonoma:  "3fc6fc394b6440a59b910c982b1d2f329eb49f83287a60fcb0447b9e1364d919"
    sha256 cellar: :any,                 sonoma:        "a6d4ff8026e6bd9c6ee17babacb726ede1dc863591482671768ce911896c46c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebe4e23e2c813e9f54a2c595be0d001fa2c4b996655ebf824b3cc6ac90fcd906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d611192872006cab783c87918881d224d29aa065d0d82b6dba753e8fccf08981"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
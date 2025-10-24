class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.22.0.tgz"
  sha256 "1b6737e1bff3ca7d1b3f661738ebf876f70752d7cecb7bdad8c22b9b3961f13a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf90df5a21a0b347443ec932c63471171c3462cf682a5c167cca7baa1bc55776"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf90df5a21a0b347443ec932c63471171c3462cf682a5c167cca7baa1bc55776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf90df5a21a0b347443ec932c63471171c3462cf682a5c167cca7baa1bc55776"
    sha256 cellar: :any_skip_relocation, sonoma:        "03372e4c536a03a8015571855af145cef7f79e611d321a658d0c8cc2fcbe92da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64133d156612592b762bf8f240749d2fec466aca7e956daf1252161e7084acb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7ad81f520f4793c4016b2db8136f2020cac9c7885ef279486d691ab1106a9ea"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end
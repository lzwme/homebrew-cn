class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://github.com/typst/typst"
  url "https://ghproxy.com/https://github.com/typst/typst/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "0f5c16c2143bbdc8889d823506e29a4706f8606ce29769916d71b17a05dda568"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "874babcb10bfe7ed485b8cc217c83d32ce318bacf1d4dcbd73cb4e7e9d5b5b75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8915c19ccc348436791435b4ccb1c38d6dc8526fcfacd2f0477cce6855fed5da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a15f853a4a66f489f110916092c0a010981ef7b5c5cd7e9b134276a44e90dde"
    sha256 cellar: :any_skip_relocation, ventura:        "bcea65451ac8ae2670f364d4f42c1aa6bd5898dfa715531d75a814d5ce9da7ad"
    sha256 cellar: :any_skip_relocation, monterey:       "cd84dbdd4a94b98b75bba3efb24ea1c10fbc931efdccf1804efa053c1952e48b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7479e7e7ae69b9123b0ded91bf8f436c7f1f0d6aa9cdf86a3a11c5f0ed573099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e54f44980fb4b4718bc61aed758dd17e2187c84970758eb73c2652461cd7db9d"
  end

  depends_on "rust" => :build

  def install
    ENV["TYPST_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typst", "compile", "Hello.typ", "Hello.pdf"
    assert_predicate testpath/"Hello.pdf", :exist?

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end
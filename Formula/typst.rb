class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://github.com/typst/typst"
  url "https://ghproxy.com/https://github.com/typst/typst/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9da7543266c7776aed56c36b9fab95fdb7241674b426cfba287a21f4cf07c172"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d74eaf00501438862a3da7d2be76450095f0d8775eb7a8f597c7fb3a3d543534"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf7603ebe7c91fa2b3d8d6d50d7fd788bb2abd79275190a5313617cca2cb32a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9936e67f13fac6fb554730193b6bfcc0f73a5286088283bed0f5d3379c0b7a64"
    sha256 cellar: :any_skip_relocation, ventura:        "1aa6ad41f2ba479ae8f908b711b3ed1b5f0689dba526f6efe2ff2db659c745f6"
    sha256 cellar: :any_skip_relocation, monterey:       "24feaec9f03c6c0561e92f778f3af871aadf2f28f79bf60170130927794d9a8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "45d9e54239b5d60b6532f84097884ed3af8eab88125a5b82ee1431e0656e7dd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2b7fc9fedd59af2d98e82ade33b1c4302c5d291274d754ba91d6be026d718cf"
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
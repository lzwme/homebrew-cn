class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "eea02a2d6bdccb67a09f85d5340a76c4daf4e91d304016028c25ae88df685e0a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "126d01b08ff1e39483063fa98bda70a5b1d784f849bfee54d98b02b056cb21c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "033f8127adee3903195925ae6570b442e349073140b1502dc4916e57f0b465c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4af710985dcef22518f866880086759a3d6f5714f148b949f2046c08ca6268c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbb4acc0f56659f9b5441fc8f354a7f79b383995afbdac7d744adea554e92254"
    sha256 cellar: :any_skip_relocation, ventura:       "5df018903eec7786b8266a1d21adf1371a526befe52214bc82863c5b905586c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ade18da76103e41c995085148f2638e58c899781eb78536476edeaa082a8398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd7235308a2ae3dbca9f921ecc4f3cc8297b0ed2ec42d7777f2c1c736a3b971"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
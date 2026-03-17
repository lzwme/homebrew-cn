class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.89.0.tar.gz"
  sha256 "8056074e7b9a6b9354500c6c5a144ee419cfc2b38a591a5b6e5376b7f6b3454a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5345389fda7baa5ab9cef9c0aecb8927a2f9de89f094eb69c8a621ff969de6b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2c0dedadb5c589198fb37cf3508b88e77d85c55eae87140f8a03eca8a3359e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a4a9748fe0e97cd670d7edbc920ff29004e9f11695d196d964926211d0370c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe7f06fdc4836f32b734e7536a67f26f52ac36c41264fa2b421b4741b6f0815b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1bd9a5b60a8610214de542613d19569fd84e7a19ff84b92f9c8a29ac384d116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2a17a31703e20cfbb080863cffeb8defea91a4c2a0f77dd9468834095801a53"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(features: "system-alloc")
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
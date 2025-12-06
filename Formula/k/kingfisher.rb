class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.69.0.tar.gz"
  sha256 "a95d8bf7d86a63aa19a7ff8ce53621d54089a15a7e099508e8a29b4aba6c9f90"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57fa570e25fef370ddb7b4da56acc59e7bfc946112d9791145770824d86381c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1ee2b3b46d5d1806cdb84fe6ee68877c59513e49068165b4c5d450b6e42f5a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0360c026bc0cbec749eebdc1dccd70af34e2f4b87c5f4192955db64d46f4243"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5f33713a66e2e2dfcfcf8d1f125d40f36303b6b7ce7d7ce1232e48c9b3b13c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6021f9a410ecfe972e27f68fa81ed58b60a049da582ae0916473ee87570c850b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80449998659e5a6f5aa55af89350e8f7137c323d64877e28be3ae998c8336451"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://ghfast.top/https://github.com/dellytools/delly/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "84abfb79bfbb8489758b76cab6908e6d5de586752892a07dd7d1c887027962cf"
  license "BSD-3-Clause"
  head "https://github.com/dellytools/delly.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4088454ed5ca7ac8670b5e960412b78096cf0e0769d9c447f07b857b1ba641b1"
    sha256 cellar: :any, arm64_sequoia: "942a2ca59a32af91288551cfc7bed4c3c6197de4bc0856ae2d9d0d050e922b24"
    sha256 cellar: :any, arm64_sonoma:  "ef4fabd74415c33bbd501eb8128bc7c549084defd4b08791f06ae0a2d4358a53"
    sha256 cellar: :any, sonoma:        "22d4e7a9de2f5499e0318cf2ed018ddcebb9c74ce54fc2d12bd7cae29cab253b"
    sha256 cellar: :any, arm64_linux:   "afd4fcfba2d743ec98b6dafe78328001a0269eefc781a6606ba29f95472d82df"
    sha256 cellar: :any, x86_64_linux:  "0ecfbcff146589ec05fdbf42d08b19ebb2777e79700fd3609f3041b74e2d44a2"
  end

  depends_on "boost"
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "make", "src/delly",
           "HTSLIBINCDIR=#{formula_opt_include("htslib")}",
           "HTSLIBLIBDIR=#{formula_opt_lib("htslib")}",
           "BOOSTINCDIR=#{formula_opt_include("boost")}",
           "BOOSTLIBDIR=#{formula_opt_lib("boost")}"
    bin.install "src/delly"
    pkgshare.install %w[example R scripts]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delly --version 2>&1")
    system bin/"delly", "lr", "-g", pkgshare/"example/ref.fa", "-o", testpath/"lr.bcf", pkgshare/"example/lr.bam"
    assert_path_exists testpath/"lr.bcf"
  end
end
class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://ghfast.top/https://github.com/DerrickWood/kraken2/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "5bbd79392ff7c530124986dfdfe126bf638477db94fb7a901ec2daf9261707f3"
  license "MIT"
  head "https://github.com/DerrickWood/kraken2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f9dcd5a087ad426dfef08436d8a8517c104eee08fac7022ff0b19c91538026f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2af9ee641dbc15c2e36617b050afd0b41587906ac574129d9407f0f1c5b59a55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19d90e268d28717c7d920f6af93a656075c6ca06b912cad818a8f0da7d58e5c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7ef796baf946db071abb11b0e5eaa227559959dbe1588a87ffb63b370a9004a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "041362df96a8f1891bedf999ce526f243a8e88982aaa26d60ccab4569b6ae19c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee5aa8fdea5f6cd1d797c2698c6386ef4be8a0da7325b2a1ca619e1885ee12b"
  end

  depends_on "python@3.14"
  depends_on "wget"

  uses_from_macos "perl"
  uses_from_macos "rsync"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "./install_kraken2.sh", libexec
    %w[k2 kraken2 kraken2-build kraken2-inspect].each do |f|
      bin.install_symlink libexec/f
    end
    pkgshare.install "data"
  end

  test do
    cp pkgshare/"data/Lambda.fa", testpath
    system bin/"kraken2-build", "--add-to-library", "Lambda.fa", "--db", "testdb"
    assert_path_exists "testdb"
  end
end
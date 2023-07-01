class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://ghproxy.com/https://github.com/lfe/lfe/archive/v2.1.1.tar.gz"
  sha256 "e5abacd57dc2f357dda46d8336a40046be806f5c6776f95612676c4b45f6d56b"
  license "Apache-2.0"
  revision 1
  head "https://github.com/lfe/lfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e296e5c53922eb67fb35c958da600e9927481f421ae56b933fa134876f1ae542"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbf6df082090844328c5e239164b23ff687c50b0c724ccd919eba0451eda7d3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2b8d1e9954758d35eb3a67d5a63abc00c7b81f9d9f82654c1410780db3d53db"
    sha256 cellar: :any_skip_relocation, ventura:        "33d4cc3579096bc2ecb3f3bcd011a97c299993b9cd5863ddb5b46beb0e86a642"
    sha256 cellar: :any_skip_relocation, monterey:       "718b1b7f946fd4883b91bbceeaa8b148154c4a1c43710526e83c9dfe2250d695"
    sha256 cellar: :any_skip_relocation, big_sur:        "33b65e4dd4df78145ea619e7f9a8fe16c1f6e6c235ab5e8ad94d906bf3633030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f186396dbd9266497928fb9b3a0e070ac1e30fa7e920b42e55229a34286acb08"
  end

  depends_on "emacs" => :build
  depends_on "erlang@25"

  def install
    system "make"
    system "make", "MANINSTDIR=#{man}", "install-man"
    system "make", "emacs"

    libexec.install "ebin"
    pkgshare.install "dev", "examples", "test"
    doc.install Pathname.glob("doc/*.txt")
    elisp.install Pathname.glob("emacs/*.elc")

    prefix.install "bin"
    bin.env_script_all_files libexec/"bin", PATH: "#{Formula["erlang@25"].opt_bin}:${PATH}"
  end

  test do
    system bin/"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+/2 0 (lists:seq 1 6)))))"'
  end
end
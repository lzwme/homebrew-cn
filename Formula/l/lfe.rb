class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https:lfe.io"
  url "https:github.comlfelfearchiverefstagsv2.1.5.tar.gz"
  sha256 "41ea68afc8bbab55c63928505ce41d91bf30751d7fc511de6d8307efdede4a4f"
  license "Apache-2.0"
  head "https:github.comlfelfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edf32df12509600b355c4ea7386998c9aa28521e2097e2863a7b342668818b9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe6cff0076fa986edb16eed7c6a4dea1151463187d2820fcb6e36321d3ea777b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89e9e752e5b700084482fc1d1a0b000bfc150054815f5102198708f0da0d3dca"
    sha256 cellar: :any_skip_relocation, sonoma:        "70f2451a495abe8cbe409dfce9be01b0a45ae249a15c954f918b9416525f5863"
    sha256 cellar: :any_skip_relocation, ventura:       "a38baee94a0ef7ba10c76761e67a91f923115650dd236d50d0994da48e1fb9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "322a3f1221587eaafe62bf0c2241b1791599bfb5c90913b82f67c89925ba32c0"
  end

  depends_on "emacs" => :build
  depends_on "erlang"

  def install
    system "make"
    system "make", "MANINSTDIR=#{man}", "install-man"
    system "make", "emacs"

    libexec.install "bin", "ebin"
    bin.install_symlink (libexec"bin").children
    pkgshare.install "dev", "examples", "test"
    doc.install Pathname.glob("doc*.txt")
    elisp.install Pathname.glob("emacs*.elc")
  end

  test do
    system bin"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+2 0 (lists:seq 1 6)))))"'
  end
end
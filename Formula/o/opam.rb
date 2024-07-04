class Opam < Formula
  desc "OCaml package manager"
  homepage "https:opam.ocaml.org"
  url "https:github.comocamlopamreleasesdownload2.2.0opam-full-2.2.0-1.tar.gz"
  sha256 "d8847873a83247b0e2b45914576a41819c8c3ec2b5f6edc86f13f429bbc6d8b4"
  license "LGPL-2.1-only"
  head "https:github.comocamlopam.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f8505fa0fbd68dad75ef1ec596083b75df6f7fa7043b15316809b847103c3e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cde882ccb2ce83fddf4097ef354476a748fd23501119063ddd6f2177e37f6c65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fde2faf7f2b0a67eb8bfd4fd74837353c7a0ad32bc397fe352ba9d82b864b30"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0b86ccdb6d32c6f874c3e04bca70d88fba1f16dbdc289330ebc5dfbd3d70a4f"
    sha256 cellar: :any_skip_relocation, ventura:        "e284961882357ec402d2d11a1bb4f2051037557ed65dd8f893277269f1aef9b1"
    sha256 cellar: :any_skip_relocation, monterey:       "f3ee80f99e716c1a7f8482c233dc3d836cc0bc242dfec8ecaedd4c6ccc0dee4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c5bbdd9cd1d5a3b2b3364df457af854cbc9a98a6ef3f299c997957d9f6b11a4"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "gpatch"

  uses_from_macos "unzip"

  def install
    ENV.deparallelize

    system ".configure", "--prefix=#{prefix}", "--mandir=#{man}", "--with-vendored-deps", "--with-mccs"
    system "make"
    system "make", "install"

    bash_completion.install "srcstateshellscriptscomplete.sh" => "opam"
    zsh_completion.install "srcstateshellscriptscomplete.zsh" => "_opam"
  end

  def caveats
    <<~EOS
      OPAM uses ~.opam by default for its package database, so you need to
      initialize it first by running:

      $ opam init
    EOS
  end

  test do
    system bin"opam", "init", "--auto-setup", "--disable-sandboxing"
    system bin"opam", "list"
  end
end
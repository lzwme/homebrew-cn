# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Applications that really shouldn't break on a compiler update are:
# - coccinelle
class OcamlAT4 < Formula
  desc "General purpose programming language in the ML family"
  homepage "https:ocaml.org"
  url "https:caml.inria.frpubdistribocaml-4.14ocaml-4.14.2.tar.xz"
  sha256 "7819f68693e32946f93358df46a8ea6f517222681fcc6f7cb96214216cfec764"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  livecheck do
    url "https:ocaml.orgreleases"
    regex(%r{href=.*?releasesv?(4(?:\.\d+)+)?["']}i)
  end

  bottle do
    sha256 arm64_sequoia:  "76e0588c99b9497463259b330659ce2f53d1c0763f89639c5f42e5503117bac5"
    sha256 arm64_sonoma:   "6abe32932e41a40ff75c1d429fc01ea3492f7a0c3281707c5ae472fba7c5db15"
    sha256 arm64_ventura:  "e63d8b519711cb181b4528efa61771cc1f0075d469fd84a7878b6efb849b6efa"
    sha256 arm64_monterey: "ea41a63891e8e0200aa517fcd0d8030cb721735d19e4cd119651d31cf2c428de"
    sha256 sonoma:         "cee37cd961b6f813bcb86b5f20c8640abf3fd691bde2f26da46a026d1fbee93b"
    sha256 ventura:        "54411358c0d919ff17a96d81a93020dcde72b2138c3cb382a67deb1df18a308a"
    sha256 monterey:       "cc525d1058ce4ef19405a80cb0dcf3af11c3a6e772fb754431c1ac1053f898bf"
    sha256 x86_64_linux:   "b9773be3973366e8d5b4d933b7cdadfd212ad9ab76dca04b709a41504b795924"
  end

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

  keg_only :versioned_formula

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the .configure in this package is NOT a GNU autoconf script!
    args = %W[
      --prefix=#{prefix}
      --enable-debug-runtime
      --mandir=#{man}
    ]
    system ".configure", *args
    system "make", "world.opt"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    output = pipe_output("#{bin}ocaml 2>&1", "let x = 1 ;;")
    assert_match "val x : int = 1", output
  end
end
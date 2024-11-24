# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Specific packages to pay attention to include:
# - camlp5
# - lablgtk
#
# Applications that really shouldn't break on a compiler update are:
# - coq
# - coccinelle
# - unison
class Ocaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "https:ocaml.org"
  url "https:caml.inria.frpubdistribocaml-5.2ocaml-5.2.1.tar.xz"
  sha256 "06cda7a23d79c1d3b36b3aa7283a5ed58798ddd871f2c269712611dc69f573b2"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https:github.comocamlocaml.git", branch: "trunk"

  livecheck do
    url "https:ocaml.orgreleases"
    regex(%r{href=.*?releasesv?(\d+(?:\.\d+)+)?["']}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "1cb7adeb65626b6c5b9963d956885356d97683f0f2a1d54d2c198a5edefbd44c"
    sha256 cellar: :any, arm64_sonoma:  "92d197de2d3c53e0b59812f4633cea69ffe0283c1e4a58ee40aaf78a0d59280c"
    sha256 cellar: :any, arm64_ventura: "bbc25adfbb86c127354d2d53d2981a4ad86daad08011b77ca32e82fd5efbe87f"
    sha256 cellar: :any, sonoma:        "97ba2b31fa0ff21902f5cf1fb12ffe1460abd5a5501ccd6737cdf860b3cac073"
    sha256 cellar: :any, ventura:       "2c59bbe9532886d0240b4d8e1c3cd084042e62d4eaadf86004dcdab7e2c47f0c"
    sha256               x86_64_linux:  "8bb80e167c8c295f6c078ab998b5f12d54c764bed796f0b576e951691c8de384"
  end

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the .configure in this package is NOT a GNU autoconf script!
    args = %W[
      --prefix=#{HOMEBREW_PREFIX}
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
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}ocamlc -where")
  end
end
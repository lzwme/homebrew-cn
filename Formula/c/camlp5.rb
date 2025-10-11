class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://ghfast.top/https://github.com/camlp5/camlp5/archive/refs/tags/8.04.00.tar.gz"
  sha256 "b00579277a5f18209a33f4adc4df04a40b5ca09e1509e702b464aa68ca44fc34"
  license "BSD-3-Clause"
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:rel[._-]?)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0edae94f33230fc6758473fc87a68015d80bd8ef27136b3894623f557c825fe6"
    sha256 arm64_sequoia: "a5de18f1d313dc38822127e6bab527b8a087e43764f3d2f73e06d34e52171ddd"
    sha256 arm64_sonoma:  "14164e78308f79fa2e5f773e123b4241358f06cb2df839df6a647c9c801c0faa"
    sha256 sonoma:        "9ac42eb31885820bdc5b222d1edb4b6d92ec2cb9a9fc41e67da7b7edc7291e60"
    sha256 arm64_linux:   "60cfb728e026cc22f80cced8efba24a63809efb2bbeaf32f0957905cf8e71df1"
    sha256 x86_64_linux:  "69739a1e454b0cff5feed77e228536406f86e0dc24a571aa3a2bb8cfb1cdeaf9"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "camlp-streams"
  depends_on "ocaml"
  depends_on "pcre2"

  uses_from_macos "m4" => :build

  def install
    ENV["OPAMROOT"] = opamroot = buildpath/".opam"
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "install", ".", "--deps-only", "--yes", "--no-depexts"

    system "./configure", "--prefix", prefix, "--mandir", man
    system "opam", "exec", "--", "make", "world.opt"
    system "opam", "exec", "--", "make", "install"
    (lib/"ocaml/camlp5").install "etc/META"
    libexec.install opamroot/"ocaml-system/lib/stublibs/dllpcre2_stubs.so"
    bin.env_script_all_files libexec, CAML_LD_LIBRARY_PATH: libexec
  end

  test do
    ocaml = Formula["ocaml"]
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"",
      # The purpose of linking with the file "str.cma" is to ensure that the
      # ocaml files are in sync with the camlp5 files.  If camlp5 has been
      # compiled with an older version of the ocaml compiler, then an error
      # "interface mismatch" will occur.
      shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo " \
                   "#{lib}/ocaml/camlp5/o_keywords.cmo " \
                   "#{lib}/ocaml/camlp5/pr_o.cmo " \
                   "#{ocaml.opt_lib}/ocaml/str/str.cma hi.ml")
  end
end
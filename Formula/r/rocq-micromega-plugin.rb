class RocqMicromegaPlugin < Formula
  desc "Micromega decision procedures plugin for the Rocq prover"
  homepage "https://github.com/rocq-community/micromega-plugin"
  url "https://ghfast.top/https://github.com/rocq-community/micromega-plugin/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "4402d9bfce88661569f3acbfff3bf4afbc6b5c8c54282b365888bac8a959f652"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e2e32190357d65fbbf5d83be1e179d75c34aa91c0f8880a365010bf6ef36277e"
    sha256 cellar: :any, arm64_sequoia: "0a19d604be6e148f6f9827e70c8859e19627523aab189a3dc8d5ae210fa39c6c"
    sha256 cellar: :any, arm64_sonoma:  "ba553c7a91ec476f65e1b78da3ed178f23c5d16f2bd639780a030a1ac2fe6592"
    sha256 cellar: :any, sonoma:        "b28cc65d8093ff84bc46ab295a26919433d73676c34b8003731ca25f3318180b"
    sha256 cellar: :any, arm64_linux:   "7fe20718dbc38c2c958706d9c3ff0aeac8c5e790011c6faf08ad9479370c9fcf"
    sha256 cellar: :any, x86_64_linux:  "44d1dcec1c04f4ead2b9f425c4e91d7673234c7339a9fe1debfce64889e4e80f"
  end

  depends_on "dune" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "ocaml-findlib"
  depends_on "rocq"

  # Only used to provide a version number for `opam install` (build-only ppx)
  resource "ppx_optcomp" do
    url "https://ghfast.top/https://raw.githubusercontent.com/janestreet/ppx_optcomp/refs/tags/v0.17.1/ppx_optcomp.opam"
    sha256 "59af9cf06bdc1d2682de3eb95bd179e48659d4dc76bd60e15feb5fbe07d42400"
  end

  def install
    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "install", "ppx_optcomp.v#{resource("ppx_optcomp").version}", "--no-depexts"

    ENV.prepend_path "OCAMLPATH", buildpath/".opam/ocaml-system/lib"
    ENV.prepend_path "OCAMLPATH", formula_opt_lib("rocq")/"ocaml"
    ENV.prepend_path "OCAMLPATH", formula_opt_lib("ocaml-findlib")/"ocaml"

    # dune 3.24 replaced the Coq build language with the Rocq build language.
    dune_files = buildpath.glob("**/dune") << (buildpath/"dune-project")
    {
      "(lang dune 3.8)" => "(lang dune 3.24)",
      "(using coq 0.8)" => "(using rocq 0.11)",
      "(coq (flags"     => "(rocq (flags",
      "coq.theory"      => "rocq.theory",
      "coq.pp"          => "rocq.pp",
      "%{coq:"          => "%{rocq:",
    }.each do |before, after|
      inreplace dune_files.select { |f| f.read.include?(before) }, before, after
    end

    system "dune", "build", "-p", name, "@install"
    system "dune", "install", name, "--prefix=#{prefix}",
           "--libdir=#{lib}/ocaml",
           "--docdir=#{doc.parent}"
  end

  test do
    (testpath/"test.v").write <<~ROCQ
      From micromega_plugin Require Import PosDef NatDef formula witness.
    ROCQ
    ENV.prepend_path "OCAMLPATH", opt_lib/"ocaml"
    system Formula["rocq"].bin/"rocq", "compile", testpath/"test.v"
  end
end
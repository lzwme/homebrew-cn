class RocqElpi < Formula
  desc "Elpi extension language for Rocq"
  homepage "https://github.com/LPCIC/coq-elpi"
  # Update resources based on https://github.com/LPCIC/coq-elpi/blob/v#{version}/rocq-elpi.opam#L18-L26
  url "https://ghfast.top/https://github.com/LPCIC/coq-elpi/releases/download/v3.0.0/rocq-elpi-3.0.0.tar.gz"
  sha256 "e32f274d14f26e139fa05af5e3dfd7e34f14ddaf6b4facc91727247a4ff22038"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "0ffd104cb899027d7e0cfdb1aa4818ce7317f1d78ee72a8e29fe9810e03eb02d"
    sha256 arm64_sonoma:  "35c834dffaa5c2b63470bb25eecf9de98e006c3ec8443e16f4a4a1e1dd4dd3fd"
    sha256 arm64_ventura: "875f9968fb393289c1198725d89c48d9bf8dc1a249b86cfeb9f9d77b962e97e6"
    sha256 sonoma:        "8e1b68853b56aca24283becc4cc3259386b19d692a3613a87a7a2ad716d0a238"
    sha256 ventura:       "964bd5a86c309e58e5fa860490205f7412a16a6416ad82ea3b4200d347b15ace"
    sha256 arm64_linux:   "dcc4426792ccd5876304c465033bb16b7e6e76460818df5eaed1ab90894b5661"
    sha256 x86_64_linux:  "944ab0f2ec8bb4680d028dd195f02fe3c3812731f5a4e43a8d8f6b71a71e17e0"
  end

  depends_on "dune" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "ocaml-findlib"
  depends_on "rocq"

  # NOTE: Resources are just used to provide version numbers for `opam install`
  # since we hit a build error when trying to install from tarball directly.
  # The result is similar to using `--deps-only` in other formulae. We can't
  # run that here as it installs a duplicate copy of `rocq`.

  resource "elpi" do
    url "https://ghfast.top/https://raw.githubusercontent.com/LPCIC/elpi/refs/tags/v3.0.1/elpi.opam"
    sha256 "7b05c5835618d5f07f32ad9a7cde2fd19f4849aca9a1d8411a4ac9d15e3b21a4"
  end

  resource "ppx_optcomp" do
    url "https://ghfast.top/https://raw.githubusercontent.com/janestreet/ppx_optcomp/refs/tags/v0.17.0/ppx_optcomp.opam"
    sha256 "9ddda7e28dabea043a0187acf3d0ff378084e0ef75c9e2003bd0350b83f4dd41"
  end

  def install
    # Use libexec as root to avoid risk of moving non-relocatable binaries
    with_env(OPAMROOT: libexec, OPAMYES: "1", OPAMNODEPEXTS: "1", OPAMNOSELFUPGRADE: "1") do
      system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
      system "opam", "install", "elpi.#{resource("elpi").version}", "ppx_optcomp.v#{resource("ppx_optcomp").version}"
    end

    # Only keep packages needed at runtime but leave them in libexec to avoid
    # incompatible versions causing issues with other OCaml-based formulae
    rm_r(libexec.children - [libexec/"ocaml-system"])
    rm_r(libexec/"ocaml-system/.opam-switch")

    # Add symlinks to reduce subdirectories in path needed to use rocq-elpi
    libexec.install_symlink libexec.glob("ocaml-system/*")

    ENV["OCAMLFIND_CONF"] = libexec/"lib/findlib.conf"
    system "make", "dune-files"
    system "dune", "build", "-p", name, "@install"
    system "dune", "install", name, "--prefix=#{prefix}",
                                    "--libdir=#{lib}/ocaml",
                                    "--mandir=#{man}",
                                    "--docdir=#{doc.parent}"
    pkgshare.install "examples/example_data_base.v"
  end

  def caveats
    <<~CAVEATS
      Rocq needs help finding ML files installed inside `#{opt_libexec}/lib`.
      This can be done by passing `-I #{opt_libexec}/lib` as an argument.
      Alternatively, you can add the directory to OCAMLPATH, e.g.
        export OCAMLPATH="#{opt_libexec}/lib:$OCAMLPATH"
      or use the included findlib configuration file, e.g.
        export OCAMLFIND_CONF="#{opt_libexec}/lib/findlib.conf"
    CAVEATS
  end

  test do
    ENV["OCAMLFIND_CONF"] = libexec/"lib/findlib.conf"
    cp pkgshare/"example_data_base.v", testpath
    space = " "
    assert_equal <<~TEXT, shell_output("#{Formula["rocq"].bin}/rocq compile example_data_base.v")
      The Db contains [phone_prefix USA 1]
      Phone prefix for USA is 1
      The Db contains#{space}
      [phone_prefix USA 1, phone_prefix France 33, phone_prefix Italy 39]
      Phone prefix for France is 33
      sweet!
      brr
      yummy!
    TEXT
  end
end
class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://files.pythonhosted.org/packages/50/33/de6ddf145bdb6c94ee25b33bc314af3bdbd15950c5a4647295da224ab58f/dnsviz-0.11.2.tar.gz"
  sha256 "ca136788bd868c03b1f2653575d899ffef41a016711655c0ee65f89c1bea3514"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8e48b3e7cb89aa85550f66524d85ed5950756c0431402824a5d9406c4f8c01f1"
    sha256 cellar: :any, arm64_tahoe:       "42faff5f1b61dbd115b70a7def664786ceeb6a97ac85bed19a143d0d9a1cd23d"
    sha256 cellar: :any, arm64_sequoia:     "43772acbfda4f9fee812c2437f529bafafcdaa41b4d25579e20f322e5dd5148e"
    sha256 cellar: :any, arm64_linux:       "e6dc72330fa9cd5f3c46c263098a658cf89d1e1e2810248e90992c4aa6d88f16"
    sha256 cellar: :any, x86_64_linux:      "18d33a674437e289bb28cb78e0677be2729eb7194f35b0273b3f76731fa43d79"
  end

  depends_on "bind" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "swig" => :build
  depends_on "json-c" => :test
  depends_on "cryptography" => :no_linkage
  depends_on "graphviz"
  depends_on "python@3.14"

  pypi_packages extra_packages: ["dnspython", "pygraphviz", "setuptools"]

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/01/f7/a82e7f47573168960ce7e2a6c937a084a14d58599fe2a48ea3cde8ca555b/pygraphviz-2.0.3.tar.gz"
    sha256 "e46818608638959ceabec66a36d2efc1d60b790a845f29705e403feecc7ee0c0"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "example-com-probe-auth", :test do
    url "https://ghfast.top/https://raw.githubusercontent.com/dnsviz/dnsviz/refs/heads/master/tests/zones/unsigned/example.com-probe-auth.json"
    sha256 "6d75bf4e6289db41f8da6263aed2e0e8c910b8f303e4f065ec7d359997248997"
  end

  def install
    # TODO: Remove when PyGraphviz discovers nonstandard Graphviz prefixes.
    # https://github.com/pygraphviz/pygraphviz/issues/630
    if OS.linux?
      graphviz_prefix = formula_opt_prefix("graphviz")
      ENV["GRAPHVIZ_PREFIX"] = graphviz_prefix
      ENV.append "LDFLAGS", "-Wl,-rpath,#{graphviz_prefix}/lib/graphviz"
    end
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.test? || r.name == "pygraphviz" }
    # Use Homebrew's SWIG instead of rebuilding it in pip's isolated environment.
    venv.pip_install resource("pygraphviz"), build_isolation: false
    venv.pip_install_and_link buildpath
  end

  test do
    resource("example-com-probe-auth").stage do
      system bin/"dnsviz", "probe", "-d", "0",
        "-r", "example.com-probe-auth.json",
        "-o", "example.com.json"
      system bin/"dnsviz", "graph", "-r", "example.com.json", "-Thtml", "-o", File::NULL
      system bin/"dnsviz", "grok", "-r", "example.com.json", "-o", File::NULL
      system bin/"dnsviz", "print", "-r", "example.com.json", "-o", File::NULL
    end
  end
end
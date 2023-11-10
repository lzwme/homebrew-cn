class Networkit < Formula
  include Language::Python::Virtualenv

  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://ghproxy.com/https://github.com/networkit/networkit/archive/refs/tags/10.1.tar.gz"
  sha256 "35d11422b731f3e3f06ec05615576366be96ce26dd23aa16c8023b97f2fe9039"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "51d5f50643575477d34fd784a2e3dbfdb6f67a7c4942c7a371d5ae1cb41888f9"
    sha256 cellar: :any,                 arm64_ventura:  "81bc8ed620831f97e3b4efb0cb119a4aae38a5faa2125b214afff45068169255"
    sha256 cellar: :any,                 arm64_monterey: "043ba6ce8f8849c9c9c24ce0328ef8b43b84d3d7e1c3dfe4e6792753184423e3"
    sha256 cellar: :any,                 sonoma:         "2e202215dbfd0abe2e8d33661a1ddccb086d3aa48c650d9a9bf92ebebbe97969"
    sha256 cellar: :any,                 ventura:        "06cdca4aa2b099b88161702de0020a028a53864fb187237da77508beeedb9088"
    sha256 cellar: :any,                 monterey:       "2357291a1153c65a87cd11c5c155fa829d676e4cf4d2dc18a60f33f7b1b9cab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a147cbbf3bdc317f42bcb876220842ff89ce29dab109cde8893e847942ee83c"
  end

  depends_on "cmake" => :build
  depends_on "libcython" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "scipy"

  def python3
    which("python3.12")
  end

  def install
    site_packages = Language::Python.site_packages(python3)

    ENV.prepend_create_path "PYTHONPATH", prefix/site_packages
    ENV.append_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages

    networkit_site_packages = prefix/site_packages/"networkit"
    extra_rpath = rpath(source: networkit_site_packages, target: Formula["libnetworkit"].opt_lib)
    system python3, "setup.py", "build_ext", "--networkit-external-core",
                                             "--external-tlx=#{Formula["tlx"].opt_prefix}",
                                             "--rpath=#{loader_path};#{extra_rpath}"

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system python3, "-c", <<~EOS
      import networkit as nk
      G = nk.graph.Graph(3)
      G.addEdge(0,1)
      G.addEdge(1,2)
      G.addEdge(2,0)
      assert G.degree(0) == 2
      assert G.degree(1) == 2
      assert G.degree(2) == 2
    EOS
  end
end
class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://ghproxy.com/https://github.com/mpi4py/mpi4py/releases/download/3.1.5/mpi4py-3.1.5.tar.gz"
  sha256 "a706e76db9255135c2fb5d1ef54cb4f7b0e4ad9e33cbada7de27626205f2a153"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d7f26ed77ae5882fe4b3df0f901f7faf51e290a94e5b6670819c5238ead605af"
    sha256 cellar: :any, arm64_ventura:  "55a18c637efd4f150d0bd0e26d6c4bf291b8c5a6cf06f767c6521a11d4de923f"
    sha256 cellar: :any, arm64_monterey: "a96bd6e4e743bb125063e7566a06944c750f91421eee383f0e074f91cc05e30b"
    sha256 cellar: :any, sonoma:         "2a9a9eb680b3d7e5f5b23a2926f0d0d123157940547c5d1f72d4447d85253d88"
    sha256 cellar: :any, ventura:        "cd1b35148ecec6ddb88a712cca2a77584e925780930bfd0c38bfd971ce282e90"
    sha256 cellar: :any, monterey:       "5387c6df33cf0b059b1b827271c54ed1ce9fe7c46e57b27450bc81d016dcc4f7"
    sha256               x86_64_linux:   "f239cce1b3d52ac7a059bb3624c84959a1c60f8479a8db858802a70097ab0f26"
  end

  depends_on "libcython" => :build
  depends_on "python-setuptools" => :build
  depends_on "open-mpi"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, *Language::Python.setup_install_args(libexec, python3)

    system python3, "setup.py",
                    "build", "--mpicc=mpicc -shared", "--parallel=#{ENV.make_jobs}",
                    "install", "--prefix=#{prefix}",
                    "--single-version-externally-managed", "--record=installed.txt",
                    "--install-lib=#{prefix/Language::Python.site_packages(python3)}"
  end

  test do
    system python3, "-c", "import mpi4py"
    system python3, "-c", "import mpi4py.MPI"
    system python3, "-c", "import mpi4py.futures"

    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python3, "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python3, "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest", "-l", "10", "-n", "1024"
  end
end
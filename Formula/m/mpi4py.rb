class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https:mpi4py.github.io"
  url "https:github.commpi4pympi4pyreleasesdownload4.0.0mpi4py-4.0.0.tar.gz"
  sha256 "820d31ae184d69c17d9b5d55b1d524d56be47d2e6cb318ea4f3e7007feff2ccc"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sequoia: "9a95ba33840080c35ea9db9966dc12fb7a568c7ce16314b668c12fc68adca7d5"
    sha256 cellar: :any, arm64_sonoma:  "64b593673a2cb086eb1ddca34612551a718e2378b3089ee92e1d8f0445d8f16d"
    sha256 cellar: :any, arm64_ventura: "99c17af7c851561b4ddd126786b78ef408951f66543248294364f04adbd71de8"
    sha256 cellar: :any, sonoma:        "0ae9bf46e9e2b972d2b3525ae6266b835cb45e1c0da56db341ee90e154b3e8ab"
    sha256 cellar: :any, ventura:       "5048281eb20ebc2ef3ae0599cb8a7a654023ace09714cbadba0d2def87119142"
    sha256               x86_64_linux:  "05e76123237f12f59d14c3dfe9a0bb3a2e62a4fa3f05546852da24da6802278c"
  end

  depends_on "open-mpi"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
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
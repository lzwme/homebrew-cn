class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://ghproxy.com/https://github.com/evaleev/libint/archive/v2.7.2.tar.gz"
  sha256 "fd0466ce9eb6786b8c5bbe3d510e387ed44b198a163264dfd7e60b337e295fd9"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c90bd617fc74a5b10427baf38495befb33bec237140d0f8a86277b42e8504b24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41c3ea9154de6b485a683072d6a120710b04434c44a169d6f5ed7d4bbb1366a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a64cc1b1626b29e086c483fa50374e0e94381cbb908c45ed5af308b79feb1769"
    sha256 cellar: :any_skip_relocation, ventura:        "aa1a324a4623b312071875a0172b31a737403d5dd1a368e1335352a98d0468dd"
    sha256 cellar: :any_skip_relocation, monterey:       "210c143e564decbec85ffc268f5e40de13b653a8d2c499e1376e29ced1d291e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "85beb94be3df414518ae137a39cf42fb54c99f14f818b191658dcca695128f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "675894076a02b63464d070cf6e0c83930d016ef492e08dd495f3830604014b7a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "mpfr"
  depends_on "python@3.11"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "tests/hartree-fock/hartree-fock.cc"
    pkgshare.install "tests/hartree-fock/h2o.xyz"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare/"hartree-fock.cc",
      *shell_output("pkg-config --cflags --libs libint2").chomp.split,
      "-I#{Formula["eigen"].opt_include}/eigen3",
      "-o", "hartree-fock"
    system "./hartree-fock", pkgshare/"h2o.xyz"
  end
end
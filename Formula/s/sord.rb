class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord.html"
  url "https://download.drobilla.net/sord-0.16.16.tar.xz"
  sha256 "257f876d756143da02ee84c9260af93559d6249dd87f317e70ab5fffcc975fd0"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sord[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "7af8265a3ffbb83bbb35f4fa4c4d8a3dac4b103d3fd03f26743f1f152dbcc0c7"
    sha256 cellar: :any, arm64_ventura:  "6f80eff9a2b7fbfc51108b0b2b4998b802774aeceec294be3bdfae4c6bd56e9e"
    sha256 cellar: :any, arm64_monterey: "4a005fb962ccf46613a4e2ac213050e488917c6cac36bc2c06e9fa752e8680c1"
    sha256 cellar: :any, sonoma:         "8d24fa7b58bfebf4369ae7dcdb636b76f1788e4f5ca919ebd26bb245412378d8"
    sha256 cellar: :any, ventura:        "17944fb44e969958791dc6e7da568409f7f493af1b776baff2ca4c25b6049608"
    sha256 cellar: :any, monterey:       "e19ca06481f3c769333b9229ce5ba8f6b547e358b8538dd01103642f6d304a85"
    sha256               x86_64_linux:   "03031f0fb3242e801b3761674d142661abfee1c4ba6a5bf28a6ae05ccddd0d87"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "serd"
  depends_on "zix"

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dtests=disabled"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    path = testpath/"input.ttl"
    path.write <<~EOS
      @prefix : <http://example.org/base#> .
      :a :b :c .
    EOS

    output = "<http://example.org/base#a> <http://example.org/base#b> <http://example.org/base#c> .\n"
    assert_equal output, shell_output(bin/"sordi input.ttl")
  end
end
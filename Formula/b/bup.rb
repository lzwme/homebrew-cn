class Bup < Formula
  desc "Backup tool"
  homepage "https:bup.github.io"
  url "https:github.combupbuparchiverefstags0.33.5.tar.gz"
  sha256 "750f8e7176a1b578484fcf4b83f2120ad1e955d2d98a26c7f64cfdb113651594"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https:github.combupbup.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3cb1f8a32f2a009da3c424bbe2a32536a2877e9b6d031821feaaef1383c3715e"
    sha256 cellar: :any,                 arm64_sonoma:  "1583f88e951dd37e4d97953ef826a2b900479657764297aac5920aa691c9a2a0"
    sha256 cellar: :any,                 arm64_ventura: "108d536dacb03b922fb62f23dc923ee560b1433d3b663cfe6ba11053713a79b0"
    sha256 cellar: :any,                 sonoma:        "53089dd890ed80ee4fa718189658d9998918dd3964de624a8565b3a5d3371b17"
    sha256 cellar: :any,                 ventura:       "da81fdddc95d7fb0605826327f96746b0231199599632976a7f2980bf1c2df33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2191edb645f94702d9e3ac9b6b6a92b096fe57074e7e26ba8cf8e76a7b24f04"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build

  depends_on "python@3.13"
  depends_on "readline"

  on_linux do
    depends_on "acl"
  end

  def python3
    which("python3.13")
  end

  def install
    ENV["BUP_PYTHON_CONFIG"] = "#{python3}-config"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin"bup", "init"
    assert_predicate testpath".bup", :exist?
  end
end
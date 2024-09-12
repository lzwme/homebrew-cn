class Bup < Formula
  desc "Backup tool"
  homepage "https:bup.github.io"
  url "https:github.combupbuparchiverefstags0.33.4.tar.gz"
  sha256 "f51284f2cb24aa653288f05aad32d6ec6ebb9546143ed7c588d40ba82f24b79a"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https:github.combupbup.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d5e14460192f0c0dad35bfcefd5b31ca061f7664fbe3e2b5c21a73a10d510987"
    sha256 cellar: :any,                 arm64_sonoma:   "0318b68039fcf8b554e28288c2fc56b3b448602fecab8535cd6bc1a7df94f785"
    sha256 cellar: :any,                 arm64_ventura:  "53a8d9dfd22c18e1a442a6897d0fc0381dc29e243a44f2b322345146c7ec3967"
    sha256 cellar: :any,                 arm64_monterey: "a66d236fc9183a6e08731af6c11024cf22998a8fe2276421d128aebbb8431783"
    sha256 cellar: :any,                 sonoma:         "3b3850de4518caee4d8efe70833b7050f1a7297abc4347dab46eb6c84e5baa21"
    sha256 cellar: :any,                 ventura:        "b2175d5efffcbfc460013f608259ca44ced450038bd4e1cdfa1857c2c666e563"
    sha256 cellar: :any,                 monterey:       "6785a85f8e7088815267b8648786cc033d1408da3922e77cce18380e657abbf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adce7c082d9fb66a0471b0728cb3c174a4a2fc1e89f3b4ac2e845ab58972b12d"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build

  depends_on "python@3.12"
  depends_on "readline"

  def python3
    which("python3.12")
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
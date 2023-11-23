class PythonMsgpack < Formula
  desc "MessagePack serializer implementation for Python"
  homepage "https://msgpack.org/"
  url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
  sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b861adc67e4320ba9c8ef9b50edec75127faa8a2502d9d8b131cc51dcb31eb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a3a8209d695cb79aa2a06e17c6f4da7561a0ffc25eab81e7f858c2e1ecf607d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51a827ca7ff68b86ebdae14c571403fd07f85670de247099e17a3e4f5a83cd50"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3cf47ffe059fccb427a15ff044fff330c3519050aec1e6eb579fcaaa30b3777"
    sha256 cellar: :any_skip_relocation, ventura:        "0f4f5454a80df69af236e1823a4c3df23ae26b30a16f44e8c4e586c949475f61"
    sha256 cellar: :any_skip_relocation, monterey:       "3fbe21909e3cac0b9530b898bf5184d43d18a88d4224f349ed019052892ebda1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f9622252d85a1b11f7f9ca7829b80f9d78a37ee5a999762e0613e45b36e7846"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "from msgpack import Packer,Unpacker"
    end
  end
end
class Isort < Formula
  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/1e/59/98677f9085b607551b009833449c39bfc4ce8172b0d9545eece9b5e2f8e5/isort-5.13.1.tar.gz"
  sha256 "aaed790b463e8703fb1eddb831dfa8e8616bacde2c083bd557ef73c8189b7263"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5244e69f49d643c8cd7f92c6f841d73bbd1e92e1ec551384358877f4fc3e6825"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cd8283d62857dc874aff541693aea9b7c9117beb8b3d8bb1273bd6b62aa2a87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "824d29c79b43aa5568fd7ccaee39af224b73cde4c0b21c632b767dde8aca61f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "93fe19d7c4a56c8282a9e24cefb2869312072fb6f956d52f4f3745653e0765bb"
    sha256 cellar: :any_skip_relocation, ventura:        "4a248de7c1f5351fec46003e2f273d1a2c02240c5b4e0cd8106be4799daa8b84"
    sha256 cellar: :any_skip_relocation, monterey:       "6905424aa448833c7138bc129813fa876f5fa342cad11fd6389aa5408a334586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a629667254ae3ba921777781a89cddb6595be53a4aa897be886683f3b17993d1"
  end

  depends_on "poetry" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["poetry"].opt_libexec/site_packages

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"isort_test.py").write <<~EOS
      from third_party import lib
      import os
    EOS
    system bin/"isort", "isort_test.py"
    assert_equal "import os\n\nfrom third_party import lib\n", (testpath/"isort_test.py").read
  end
end
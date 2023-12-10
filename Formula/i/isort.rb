class Isort < Formula
  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/42/c5/e8a34dace89624d27c31c67140362cfe07562c450c52984419ee242f0fcb/isort-5.13.0.tar.gz"
  sha256 "d67f78c6a1715f224cca46b29d740037bdb6eea15323a133e897cda15876147b"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77fe9468b682b2b7839ba3f6e95368c77f08fc5de36dd55c0c7a7f26d7a02a63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6c818f7bb848bf95078f44739d8528a835f0b7b8901e8763b62e2c070c6030a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95209b69d4cb24525973b54b30ce851988a6106fcd7367191c6cddea059c7061"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d208c0aea4d1cf1516644be814fe9085f8d309cbc178295c5cdc07c61a73712"
    sha256 cellar: :any_skip_relocation, ventura:        "18030ccc7096649969220480a7a57393fbc19c551dbe7a3ac7bf3a00484c3e52"
    sha256 cellar: :any_skip_relocation, monterey:       "cb38d9eff72ce12724ff391ad0812c5c7965c062cf4b74c326e2e877e97d58eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23638a9f6c0492dd46481c5211d3313e1d45fb657f59b8b6d9b7b90436cd38f0"
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
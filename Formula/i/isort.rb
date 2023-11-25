class Isort < Formula
  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/a9/c4/dc00e42c158fc4dda2afebe57d2e948805c06d5169007f1724f0683010a9/isort-5.12.0.tar.gz"
  sha256 "8bef7dde241278824a6d83f44a544709b065191b95b6e50894bdc722fcba0504"
  license "MIT"
  revision 1
  head "https://github.com/PyCQA/isort.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "379756d92cda291dd3c986207bf8354929f7cae2fb6fa70328f0910a531cdfb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "379bf2302bf9350adcf9251c1cea0a20dd866709767d51fc6202be875c9a0cc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f56fdf2cc55f864921c976d6072f05cb5710ba56ba4af18e1a0f568f880f4ed2"
    sha256 cellar: :any_skip_relocation, sonoma:         "96edf8289f409494428280909766438e1e85fc265944f050ae224e8552aca67b"
    sha256 cellar: :any_skip_relocation, ventura:        "7cef353885a0141c0f3dd1ee56270caca837c475ada8f075ec47fff7aef69da9"
    sha256 cellar: :any_skip_relocation, monterey:       "f872bfceb6a103a01535962cdc79dd6b2242bca96f002cf279f06ff2ce52b62d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4de6b3973615de88f487ef0db6635fde93638ab0e841b792029d805526ac0306"
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
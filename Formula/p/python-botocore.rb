class PythonBotocore < Formula
  desc "Low-level, data-driven core of boto 3"
  homepage "https://botocore.amazonaws.com/v1/documentation/api/latest/index.html"
  url "https://files.pythonhosted.org/packages/8c/bd/0068ae84de8a3d95584a220cae5e84fefeec52371112d623369d40a7306b/botocore-1.34.9.tar.gz"
  sha256 "2cf43fa5b5438a95fc466c700f3098228b45df38e311103488554b2334b42ee3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1352d870a484316b354d81c83e9da32e2d3e2092b884451ae0395a27c294d02f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c35bf71ca65e3c9bbb9537a4e446e3ee007c8a637b0178e29995926e856f1046"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1bae188a11e4f02fdfb6048dc219c7b958465682ee825b759d26462eb36a4cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d488e62c162b99cffd128c4af7e6279913081d2f18bc828a969516cec325b6c0"
    sha256 cellar: :any_skip_relocation, ventura:        "1f0b9d0bc8c54100bd1d871b44a669dd7c7627f03f58bb2b7cfcfefe50c19777"
    sha256 cellar: :any_skip_relocation, monterey:       "1be3147dcf0cfbbb45481947e90845c97e12571b33d4cbcb4f6a23378cdcdcfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "284f298c827ef495b424147553f2af0e6d4000f3282d21d5b50c6fd4c7e5ce77"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-dateutil"
  depends_on "python-jmespath"
  depends_on "python-urllib3"
  depends_on "six"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from botocore.config import Config"
    end
  end
end
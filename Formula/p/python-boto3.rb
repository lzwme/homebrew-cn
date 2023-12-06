class PythonBoto3 < Formula
  desc "AWS SDK for Python"
  homepage "https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/index.html"
  url "https://files.pythonhosted.org/packages/47/87/87aa0bedda7591bb7da730a415c2ba8520c80e0a5011648de5ede40aad9d/boto3-1.33.0.tar.gz"
  sha256 "ebf6d86217c37986f965dbe35a3bbd0318127d23a65737ab6486667496decb54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92df1427c96038319b290bdbcb47bfeece5479de746b08c8c84d159b53a83e12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ad122af546b4680355c06ee45ae1b56670be1493adef88860e93542ed63248d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d431bab8ac9bd9c7e5636338cc23f4e3be30218591d0ef9e71ef9963d759581f"
    sha256 cellar: :any_skip_relocation, sonoma:         "06c28686da1d35d33581243b62e55455ebd7ee60b974530c1f93d10900371624"
    sha256 cellar: :any_skip_relocation, ventura:        "67b69f4f2d32f09f3aa47254151663797aca70334b29ce8efd987c53e6db085f"
    sha256 cellar: :any_skip_relocation, monterey:       "8c3ede2c4c7799146bdb33a1d878591fc67632fba69a9cc9e7844d54f64f70f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68ed27c847e1075678e09d39f8b0da39354d28af2992de0120436fbcf9563006"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-botocore"
  depends_on "python-s3transfer"

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
      system python_exe, "-c", "import boto3"
    end
  end
end
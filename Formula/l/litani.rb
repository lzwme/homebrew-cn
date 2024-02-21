class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https:awslabs.github.ioaws-build-accumulator"
  url "https:github.comawslabsaws-build-accumulator.git",
      tag:      "1.29.0",
      revision: "8002c240ef4f424039ed3cc32e076c0234d01768"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "408a0d598275dc4a3871764f95d3d7ddc0826a343ebf4dd7596b57b51f9bbec4"
    sha256 cellar: :any,                 arm64_ventura:  "93b45f62fedbde680a8d8f8790492199d3de3f3474b034d9588b6fe0dfea6e71"
    sha256 cellar: :any,                 arm64_monterey: "b37771876e6b276e86044e1de6ac2b827531158f361d23e564145a23d93b782c"
    sha256 cellar: :any,                 sonoma:         "96a1153878cfd5873fa3826c3ad52ccdcbc5d61961f11b12c89a8551fdc64055"
    sha256 cellar: :any,                 ventura:        "05d05b60fb1ff44f6a3eff263a971ef53f5e3e46c52ce36f565f6c1f78d07eb4"
    sha256 cellar: :any,                 monterey:       "e9a74083982b0345fcafab7158af89e0889b342441ff7634a7defbf356e5bd43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74a1598f4a7d1f14a4c55bf1c4e775e75dba57267bb0a795627fc97a41bc5467"
  end

  depends_on "coreutils" => :build
  depends_on "mandoc" => :build
  depends_on "scdoc" => :build
  depends_on "gnuplot"
  depends_on "graphviz"
  depends_on "libyaml"
  depends_on "ninja"
  depends_on "python@3.12"

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackages7aff75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cceJinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages6d7c59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbfMarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    ENV.prepend_path "PATH", libexec"vendorbin"
    venv = virtualenv_create(libexec"vendor", "python3.12")
    venv.pip_install resources

    libexec.install Dir["*"] - ["test", "examples"]
    (bin"litani").write_env_script libexec"litani", PATH: "\"#{libexec}vendorbin:${PATH}\""

    cd libexec"doc" do
      system libexec"vendorbinpython3", "configure"
      system "ninja", "--verbose"
    end
    man1.install libexec.glob("docoutman*.1")
    man5.install libexec.glob("docoutman*.5")
    man7.install libexec.glob("docoutman*.7")
    doc.install libexec"docouthtmlindex.html"
    rm_rf libexec"doc"
  end

  test do
    system bin"litani", "init", "--project-name", "test-installation"
    system bin"litani", "add-job",
           "--command", "usrbintrue",
           "--pipeline-name", "test-installation",
           "--ci-stage", "test"
    system bin"litani", "run-build"
  end
end
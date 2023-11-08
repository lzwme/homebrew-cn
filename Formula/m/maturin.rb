class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghproxy.com/https://github.com/PyO3/maturin/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "9e4f6cf2b5127103042d7319e9cbeee3df5b429c3c29b930fd360cbf8da84828"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0d223db2b214366ed6f35f44aaa0ecb09b814cca08469eabcbc4597862a375cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3224e0f21bc8b045d8921ecaf156433dd30bfdbf437de1cd9e7490c15b31747"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53e6a2c3ae745df6c69d1d736ee43142020d170771f1a5b9d61bcf84800078c3"
    sha256 cellar: :any,                 sonoma:         "c09056f41f176e1a7b80971c5f754c7be18e368cab6ddc2ac24c50206bb6e66a"
    sha256 cellar: :any_skip_relocation, ventura:        "1556e7b56f062c8091829ee73134ccae258efd875b0a0a6dfeb6b2a72207b9cc"
    sha256 cellar: :any_skip_relocation, monterey:       "fd6e77c547732b200d4d8e6f053cf0efd976bb46098d4ea01f904e5526b74727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6844f259b9c0cdc45c384dfcc70e54f34284635117a44814ba52315cc8f6a21"
  end

  depends_on "python-flit-core" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-typing-extensions" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "rust"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/f2/40/f1e9fedb88462248e94ea4383cda0065111582a4d5a32ca84acf60ab1107/setuptools-rust-1.8.1.tar.gz"
    sha256 "94b1dd5d5308b3138d5b933c3a2b55e6d6927d1a22632e509fcea9ddd0f7e486"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  def pythons
    deps.map(&:to_formula)
        .filter { |f| f.name.start_with?("python@") }
        .sort_by(&:version)
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python)
      resources.each do |r|
        r.stage do
          system python, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python, "-m", "pip", "install", *std_pip_args, "."
    end

    # overwrite the minimal binary that pip installed
    system "cargo", "install", *std_cargo_args, "--force"
    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    system "cargo", "init", "--name=brew", "--bin"
    system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
    pythons.each do |python|
      system python, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
    end
  end
end
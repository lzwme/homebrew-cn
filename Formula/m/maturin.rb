class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghproxy.com/https://github.com/PyO3/maturin/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "4506920ebe88401de129b5d5579c433ba0702192aa0e0537f97520d3719c4d2c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7bdbfd174fa1572f9ab360c8a38aedba4bc2aa1e653d068002c653301d7eccf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bd5208acfbe86f8e05044fa22bed6cef0727158d418c63c8e18511945904b4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e46fa52cf95fbeae78f795cc19abd23c36e30f1efc1261351a54c9313ea1eee"
    sha256 cellar: :any,                 sonoma:         "e8bfc615d80fdb97f53ef7f97b48739ba709a975d8fdaf5f95f8a1e545c96d24"
    sha256 cellar: :any_skip_relocation, ventura:        "c5aed950054a89f615ff4b19b51f5c0c1298d75c5d9bf20d90c3452bddc98464"
    sha256 cellar: :any_skip_relocation, monterey:       "5e6d9537322923af9bd8087c36ebf92d35f771280c19a412a53b2a9f627f6926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c63ffadc624a3d60e5d609da31b39f011feec90905096304e14ce60381da9586"
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
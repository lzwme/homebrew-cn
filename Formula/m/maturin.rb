class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghproxy.com/https://github.com/PyO3/maturin/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "cd2cd3d465619bb997b41594398310e8b257d0c17854a58ca0598efa11e6d698"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64ec4a89818ab95ba00f13a23997ac689cb9e7ce4ff48b708f680e5fc9ab7dd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3b54ab4b2ab9f96eb1cf5be316ff10de2363db05f815573d084c9b14dba1058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90b9305c1207a4ec2f2a482410b6524bed93d2a972c840a2fc18bbb172a54e1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0384fc15d842cc847746e821385faaaf402d95ade060d219eb84c7544899039"
    sha256 cellar: :any_skip_relocation, ventura:        "4ff77a7e28cb5e129f9dd7ebe23edbd60cac9f98391092ef6a2254ca8d560fa3"
    sha256 cellar: :any_skip_relocation, monterey:       "00fe92b56cf5f9fd6011a0951a206c9c18a6e377b80494d4add129c38bdcc31a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e710b982773b61be38c52093d0bfc6d5917853140fcead1e5a6e8bd66571902"
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
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      ENV.remove "HOMEBREW_LIBRARY_PATHS",
                 recursive_dependencies.find { |d| d.name.match?(/^llvm(@\d+)?$/) }
                                       .to_formula
                                       .opt_lib
    end

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
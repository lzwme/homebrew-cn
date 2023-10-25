class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghproxy.com/https://github.com/PyO3/maturin/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "9e4f6cf2b5127103042d7319e9cbeee3df5b429c3c29b930fd360cbf8da84828"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0e45b7a2d535bbc539327687093a7ce498b9590370ed0abb307b990f66b05fcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e4e26c816e8113c78eb6f5112f142cb461f7b0a8335467ea005c8aaf3038845"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "846bf2f1441b7c06c38390e7c91b00c53f703009698c78d6153c992d43cb81cf"
    sha256 cellar: :any,                 sonoma:         "cd4df1996bb2c0caf784a45418f790d0e211591ce2bb05573635bdb356b5619e"
    sha256 cellar: :any_skip_relocation, ventura:        "d168165b411d2d24b42d8d1d23a791ae2241526a7820d50cb335bf26af6f5436"
    sha256 cellar: :any_skip_relocation, monterey:       "cb1a7d07e00a47344116ed6642a8ba912d885fc4cb8d2ec6b9a8b447ac1f9fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26a741013b0ec745058271428c50854277bbcfd9681b8eb5e32d44991b75dc85"
  end

  depends_on "python-flit-core" => :build
  depends_on "python-typing-extensions" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "rust"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/90/f1/70b31cacce03bf21fa645d359d6303fb5590c1a02c41c7e2df1c480826b4/setuptools-rust-1.7.0.tar.gz"
    sha256 "c7100999948235a38ae7e555fe199aa66c253dc384b125f5d85473bf81eae3a3"
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
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    pythons.each do |python|
      system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
      system python, "-m", "pip", "uninstall", "-y", "hello_world"
    end
  end
end
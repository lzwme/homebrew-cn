class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https:github.comPyO3maturin"
  url "https:github.comPyO3maturinarchiverefstagsv1.5.0.tar.gz"
  sha256 "19eacc3befa15ff6302ef08951ed1a0516f5edea5ef1fae7f98fd8bd669610ff"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comPyO3maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac6f489ca22aa4f6cb411b7ee0fc36d6fbaa6e6b940e0cce811a512d8d29557c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d84c0788904a7553bed9991e24beaa51565dce98b0e2883fbf3ab5c63a829e8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebbee243e035f679192422efffc84688b95f2b30793882debe999d6b990a945d"
    sha256 cellar: :any_skip_relocation, sonoma:         "03e2117430b88ad8219937bed7d08340c6745889dad57933ec9e8a6d0dabb8ba"
    sha256 cellar: :any_skip_relocation, ventura:        "799978386674d99008a88d45cfa659747b01cd4efe38497d78b0bcf995dd0839"
    sha256 cellar: :any_skip_relocation, monterey:       "e4a31781cced921fc214d6610778efcf2e31566c2a7569e246fa66370df44ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c6f2f3baa0da92565d5af8102220ec9a711759407ab8435198f2c1b52acf371"
  end

  depends_on "python-flit-core" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-typing-extensions" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "rust"

  resource "semantic-version" do
    url "https:files.pythonhosted.orgpackages7d31f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools-rust" do
    url "https:files.pythonhosted.orgpackages9df12cb8887cad0726a5e429cc9c58e30767f58d22c34d55b075d2f845d4a2a5setuptools-rust-1.9.0.tar.gz"
    sha256 "704df0948f2e4cc60c2596ad6e840ea679f4f43e58ed4ad0c1857807240eab96"
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackagesc03fd7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  def pythons
    deps.map(&:to_formula)
        .filter { |f| f.name.start_with?("python@") }
        .sort_by(&:version)
        .map { |f| f.opt_libexec"binpython" }
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      ENV.remove "HOMEBREW_LIBRARY_PATHS",
                 recursive_dependencies.find { |d| d.name.match?(^llvm(@\d+)?$) }
                                       .to_formula
                                       .opt_lib
    end

    pythons.each do |python|
      ENV.append_path "PYTHONPATH", buildpathLanguage::Python.site_packages(python)
      resources.each do |r|
        r.stage do
          system python, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python, "-m", "pip", "install", *std_pip_args, "."
    end

    # overwrite the minimal binary that pip installed
    system "cargo", "install", *std_cargo_args, "--force"
    generate_completions_from_executable(bin"maturin", "completions")
  end

  test do
    system "cargo", "init", "--name=brew", "--bin"
    system bin"maturin", "build", "-o", "dist", "--compatibility", "off"
    pythons.each do |python|
      system python, "-m", "pip", "install", "brew", "--prefix=.dist", "--no-index", "--find-links=.dist"
    end
  end
end
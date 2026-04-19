class Pydantic < Formula
  include Language::Python::Virtualenv

  desc "Data validation using Python type hints"
  homepage "https://github.com/pydantic/pydantic"
  url "https://files.pythonhosted.org/packages/09/e5/06d23afac9973109d1e3c8ad38e1547a12e860610e327c05ee686827dc37/pydantic-2.13.2.tar.gz"
  sha256 "b418196607e61081c3226dcd4f0672f2a194828abb9109e9cfb84026564df2d1"
  license "MIT"
  version_scheme 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bfa768c64da122b367739b9a404c2acf1ddcb980277a4a6c7ddfc4e58177df59"
    sha256 cellar: :any,                 arm64_sequoia: "68e215e5296415c2e924b3049b57d24ad5e0f661a7a95ef40e1053e6741b7111"
    sha256 cellar: :any,                 arm64_sonoma:  "1885b7f395a73d94045063236a4a5285d5f15db41737b2a619cfce59d5704ea0"
    sha256 cellar: :any,                 sonoma:        "d96f7771a5b904da38d64e24292cbc6ab59420b062ede2632c4ff5f71767ec63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3db0112a04599e2081d52248c8cc07a13c5d81ec94ee673a4ac0464db4a0af2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "805fe8e1be985e75ccbb49254b9b9e3b92cf0573fd6633b36801f2fbdb9ca830"
  end

  depends_on "maturin" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/43/bb/4742f05b739b2478459bb16fa8470549518c802e06ddcf3f106c5081315e/pydantic_core-2.46.2.tar.gz"
    sha256 "37bb079f9ee3f1a519392b73fda2a96379b31f2013c6b467fe693e7f2987f596"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  def install
    pythons.each do |python3|
      resources.each do |r|
        r.stage do
          system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    pythons.each do |python3|
      system python3, "-c", "import pydantic;"
    end
  end
end
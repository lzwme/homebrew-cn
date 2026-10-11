class Pydantic < Formula
  include Language::Python::Virtualenv

  desc "Data validation using Python type hints"
  homepage "https://pydantic.dev/docs/validation"
  url "https://files.pythonhosted.org/packages/6b/fb/6e44b63b26efea1cec48c26d8362313310202ef5ed6e7a52f1669e64e2cd/pydantic-2.14.0.tar.gz"
  sha256 "8a51a7aaddd60f55566d1f07bdd87b92b463903f39a8f26b71a06314cd1548ae"
  license "MIT"
  version_scheme 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0a79643e5657b2ec54352b7010eabb3d5945077138a152c9609bf5ff9c036001"
    sha256 cellar: :any, arm64_tahoe:       "f298c16202057efa68e39e4a5d3421edd4a5c1088f18821716c8901cd8dea67e"
    sha256 cellar: :any, arm64_sequoia:     "0bc97dac3b376f3f3448104206494966a49c64fd10bc4f209133f34f4284fa80"
    sha256 cellar: :any, arm64_linux:       "6a9f8f56a01a5eefd8b5adc4f719cd94b794402280b09103aefad548e9281a3f"
    sha256 cellar: :any, x86_64_linux:      "138b274aa39f47f9d859139f290100c99baf672a79b1d1ef5ada98b2be791762"
  end

  depends_on "maturin" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
  depends_on "rust" => :build

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/5f/56/a8120250d128bed162cd73c76d45f6ef9991f3e068f62a8ee060afa3104a/annotated_types-0.8.0.tar.gz"
    sha256 "13b2beaad985e05e2d6407ee4c4f35590b11f8d693a258a561055cac8f64cab7"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/e6/6d/196e8c819e0e934f35a1a33b3530396feadb0af4ca38fe9f995249e55794/pydantic_core-2.50.0.tar.gz"
    sha256 "84d2d38f7d163c4dec292f379e9de1960c661795442aca6c90d706436cb3749e"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/a3/26/b09b8010994eccc3c09092e6b34058f36a460eea2d4c3e8b910c695975a0/typing_inspection-0.4.4.tar.gz"
    sha256 "547274fa6b0a561ccf549cc9524b999a578e737d015d8709d021f9d0d13bea47"
  end

  allow_network_access! :build

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
      system python3, "-c", <<~PYTHON
        from pydantic import BaseModel, ValidationError

        class Model(BaseModel):
            value: int

        assert Model(value="42").model_dump() == {"value": 42}
        try:
            Model(value="invalid")
        except ValidationError as error:
            assert error.errors()[0]["type"] == "int_parsing"
        else:
            raise AssertionError("Invalid input was accepted")
      PYTHON
    end
  end
end
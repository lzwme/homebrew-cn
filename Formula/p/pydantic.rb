class Pydantic < Formula
  include Language::Python::Virtualenv

  desc "Data validation using Python type hints"
  homepage "https://github.com/pydantic/pydantic"
  url "https://files.pythonhosted.org/packages/f3/6b/1353beb3d1cd5cf61cdec5b6f87a9872399de3bc5cae0b7ce07ff4de2ab0/pydantic-2.13.1.tar.gz"
  sha256 "a0f829b279ddd1e39291133fe2539d2aa46cc6b150c1706a270ff0879e3774d2"
  license "MIT"
  version_scheme 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a9c9aebc9e8ebf370f5ef42a7ccb984c27a8b8741ce05c5f03942938f17cda5"
    sha256 cellar: :any,                 arm64_sequoia: "595a34fc3e89152f3e82a9c355a69600ab54d813474ca2a673ef72caaf4ab63f"
    sha256 cellar: :any,                 arm64_sonoma:  "547374c5d8cfb8414b7cf4a9e44e862c2e81d1f27eaa80d75da1941e485dfa8d"
    sha256 cellar: :any,                 sonoma:        "a4860826e70f1cd9b5a2823e0c96f77045de9df1876f66c1c03368d524dcca62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75c17f04faf3f8cebd50d23d883c11db397459076a13f0c3db407740d3b2a3d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7facbfcd0b6727ddfbed17d998b667783aeeff7204bdd7bcec99f0ec0992751"
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
    url "https://files.pythonhosted.org/packages/a1/93/f97a86a7eb28faa1d038af2fd5d6166418b4433659108a4c311b57128b2d/pydantic_core-2.46.1.tar.gz"
    sha256 "d408153772d9f298098fb5d620f045bdf0f017af0d5cb6e309ef8c205540caa4"
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
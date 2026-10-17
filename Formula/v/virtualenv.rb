class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/0b/6a/fbdeea5c07d5674139639d42a97a41d26e9b9b8cb2a1265fa936f655ee20/virtualenv-21.14.8.tar.gz"
  sha256 "394e45ed610ceffb5018e1a179e3a8012c02fd87fe792ab4aae67ce5e7e3afbd"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6bad1b3224cecced703d9635b115115fe7611ef8b42f4afbc32a7af0e5e0eaea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6bad1b3224cecced703d9635b115115fe7611ef8b42f4afbc32a7af0e5e0eaea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6bad1b3224cecced703d9635b115115fe7611ef8b42f4afbc32a7af0e5e0eaea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "12e5c2056737ca7d87760ecad2d24539ebdf443659685244b3f2d9a9ce58ff64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "12e5c2056737ca7d87760ecad2d24539ebdf443659685244b3f2d9a9ce58ff64"
  end

  depends_on "python@3.15"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/f4/a9/1af41b37c3279712b22cdc63aac78a52432202b6fe1f9666a2a3d2831fb4/filelock-4.2.0.tar.gz"
    sha256 "7a60906c75227cf04d0c273afadc8219400f11aeb13cc69591d4f6cdc6c8036e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/da/91/4a03cfdb03314cfca262921797fff04ff4054bd86a160aed76eddf8aa12b/platformdirs-4.13.3.tar.gz"
    sha256 "5e567f664eb087ab8521c0179cd8d1bd60857d271136567a39719e28e2d383ce"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/b0/73/54993df8fc57e906dc9b7e01d1d9b0b2d3eb0ce3190639e33dccb12853f7/python_discovery-1.6.2.tar.gz"
    sha256 "cd1738ca1d37c86ef9d0b654dd46fcee1e41c97c6add12575e8501ced39afdb4"
  end

  allow_network_access! :build

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.commitsuhikoryearchiverefstags0.22.0.tar.gz"
  sha256 "225a810165679a50a68e033f841be296fc592f3241cdcf5ef14345994b296381"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7455206c775e1f52945c6c92c704be315e32838618ca75feebcd2076c999b28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f7eeeb82e1a8ba1f325cd8f98730c84518aa4a0f3ea8ba6af606ea5d1140319"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2f6ee7aedffddc5f53c68316c248b8c5d2bb9680808496d5f005122c78af8b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f20329f387c3839fccf75129dce95d50533d9572abb5116482fa1d5fef8fcb71"
    sha256 cellar: :any_skip_relocation, ventura:        "e9097c9f2879bada752ea214d59162ae50054155968889293b80244a841efef9"
    sha256 cellar: :any_skip_relocation, monterey:       "f4373af74a93adebb6a3bf5847468c14333fb6c423167891eaa7dc916c2a8133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc1b5ea0353e592d381f67aae0494fc3958343e54d50fda0ae8ac7c74b530e48"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin"rye", "self", "completion", "-s")
  end

  test do
    (testpath"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    EOS
    system bin"rye", "add", "requests==2.24.0"
    system bin"rye", "sync"
    assert_match "requests==2.24.0", (testpath"pyproject.toml").read
    output = shell_output("#{bin}rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.commitsuhikoryearchiverefstags0.25.0.tar.gz"
  sha256 "b17eaeda2159a050344e99efa2e225983af8d61d2b025ab33036e48a11ebe714"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69c966d0d4e4308d03d43daa9d0c48faa60dc84841c168b5f78ffa648f914a49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98df454e2faa0c9eee8d0c417f48c02e3823b4e9ac6a2032cc29bd6f992fdf71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "010e8afc09953804d706c087229d6d48285cd38e145945c8cc33ec8bd3c58250"
    sha256 cellar: :any_skip_relocation, sonoma:         "67221c42a3877b9d55c28d3b79659e62ea56da29048a713cee5bd7378044a56b"
    sha256 cellar: :any_skip_relocation, ventura:        "1c991cf142e60206366b808cde6ef7811467a9d68220d9117512e1243ca8a29d"
    sha256 cellar: :any_skip_relocation, monterey:       "a87dfd1309a89bb6e6fb8bf9a777b9236c713547b200b2b9e05f64a35ebf5d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13985f9509ebdbd1f2e14ce7634e4ce8dc23113ef3f154e66d769421f1593b3f"
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
class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.commitsuhikoryearchiverefstags0.32.0.tar.gz"
  sha256 "471e6164c1c1515b8ba7e536dfa7ba6054b5fec94a07f54608ea3a01c8408460"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e826730270d2fef8dd542fd070b19c78e0fde8ffece921c9f7c8d858af6abb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5632fed9b5d39c6e061f60d47f13e9e28f72c9da64cf1978c4dc3919a5522767"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "250220a293891e1eb041dac6e4ec6fb9f7f4f060a9383b03c6514835704cd6af"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc7299a49343ddd8fb2d50f9e1facefeea1bf30d870982a9d40130ceddc6ffaa"
    sha256 cellar: :any_skip_relocation, ventura:        "a9c395a146eae22220e59fe68d42c1420a42827493902185e8156cab6a998683"
    sha256 cellar: :any_skip_relocation, monterey:       "57cc3ecebcaf929115063f2535541dce7937985431bb90f596e4992fb086d071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e005eb2d11525b31603f191f8af8b41b3779382bde5442a8f100b0af03ce106"
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
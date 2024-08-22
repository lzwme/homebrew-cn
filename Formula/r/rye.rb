class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.comastral-shryearchiverefstags0.39.0.tar.gz"
  sha256 "359afd0c0badf0524cecbf66761ad499f8deb26f287c5391c8996a8914dfed7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1dd860982e82c4720732a82691f1c6973c0bc5e4abea37e660ec6a3174c305c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63bddc579facc960290a8f52a61d2b46f4c26466d65307c2d46b2713a8f1ebf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11887f4526edc30f8873a5b8e91eb495977bcb9fadeecc9589612b79da7b936f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b71f2102156a7c1c4e3775834d4782d6afed1a93d14e72b0a6ad1e1fca5e1fec"
    sha256 cellar: :any_skip_relocation, ventura:        "361f5b28eaf560613427f4a55afabd9d47d90dad122c551d3b60908d9c591943"
    sha256 cellar: :any_skip_relocation, monterey:       "636bf1fe3401a311119026f3d0e0d23c8cee2f4a5437e25a9ef1125620d80bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21638f1f5c42b5897507bedc9c233fc37a6a5e101e0efe55868e45a7a35c1626"
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
class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.commitsuhikoryearchiverefstags0.21.0.tar.gz"
  sha256 "ce11afdf37357f6c24c705c89881d745bf2b4b1fafa64168123791dcdbe734eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10c2e36bdab787d1973746bf343113aac0a0e4e930aa49c7ed09cd8eb32e4a39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5da2dc89effd0cbc26ec0a7f45e1e444a5f8edfca66cfc2bd971c2a9c8f71919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c29957ef1b3a554abf57d98f574aad61e83eafc33fbaa1b9ce3967e596aca0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "37c8af69af45f93590a4cc6839d3471ebd002356180db133227e7d64e6934e2a"
    sha256 cellar: :any_skip_relocation, ventura:        "64b2ae3d1ba60c20c0d1437dc95f616b2dd1db9af89f5182cb6c370babf3a717"
    sha256 cellar: :any_skip_relocation, monterey:       "6dad950fdc37158425c145f0e8e38aa2736999d2c2904358cbf51789a246453c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff24a1dd83be289b32fe32a6ab8934d8d5b6a7dd65aaf057f4e4601b014be21e"
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
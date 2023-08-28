class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://ghproxy.com/https://github.com/mitsuhiko/rye/archive/refs/tags/0.12.0.tar.gz"
  sha256 "9d66b07d4b6b20864f6f070af175e7d58fbfa8109a1809facfbeea1e4e2a5b6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f9fc32adfdda8dc5f3f0a383e9bf9f40631c2391be677ed98c947c528045299"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aaa3115f050baa385255b77e491829c20e8a5545f26d13a791418262db2ead2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "936fb077e817969b2601695db373a400b3054d4920d018472ba6ce1593441f15"
    sha256 cellar: :any_skip_relocation, ventura:        "c283958a37f12889db4820df3c77d007243fe81c967bb13efde217e1bf9c5b28"
    sha256 cellar: :any_skip_relocation, monterey:       "93b90d5b0269a4efae95bf2fcd946ed2ffae9964a4101a92d1bbc701041725f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "33a7b0a62e3c36c9c17b552914668de7f512d0fc29e52a7b21caf46c10f54ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95643c527da564aa9496d90ccd7d711fffa6a926d5bdaebedaac64a6641ea731"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin/"rye", "self", "completion", "-s")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    EOS
    system bin/"rye", "add", "requests==2.24.0"
    system bin/"rye", "sync"
    assert_match "requests==2.24.0", (testpath/"pyproject.toml").read
    output = shell_output("#{bin}/rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
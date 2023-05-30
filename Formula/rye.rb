class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://ghproxy.com/https://github.com/mitsuhiko/rye/archive/refs/tags/0.4.0.tar.gz"
  sha256 "d952db5019576e523aa60a87bf1fbf9f44dcc5676a644b4fc3a51fb98f99952f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d66ea0f1d27c80d6ff0b047601375dcb5208f46c56a3c168494baa02b01e280"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8498d78ce5d9f99e6629a4d1dd6ac81a319a16aa982a102de8fdbd547cea5d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9174b51ccb30eef77d57a519f7b3a42bf2411971a806329a1ce5fd9b8b55b152"
    sha256 cellar: :any_skip_relocation, ventura:        "382bec180b6a22a2aad527067ee8c5f2c2f995a4cd95ed2af46de0a2a92c8a3d"
    sha256 cellar: :any_skip_relocation, monterey:       "085671830b1bcb91bbf68212fe40366451c1b6b1ac71d2ff1e927febc3c75458"
    sha256 cellar: :any_skip_relocation, big_sur:        "183000b316b46e3f35631554199e88ae50b7c8d014ef17523f72b4ae2747966e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbd36d272f605566f94b09a2b8f36f50cba913db29f0edec835af2848061ecc3"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

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
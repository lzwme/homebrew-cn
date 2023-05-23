class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://ghproxy.com/https://github.com/mitsuhiko/rye/archive/refs/tags/0.1.2.tar.gz"
  sha256 "7ae00b1e377ee279eae74d4b4a6d63ec4fe89ec70d408926912faa11b42ace46"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da27dc47aa609c06bc574f62677b14ae8c5d02ddf14ae9f719530d73c1069d2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18a1f0b8fa32d638be9f7d6acd831338cf923baee4ad33d9c87f1c372eadb6f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "853d9ffa21b77a496a7b0fc8e843ccafb34f8aab3d7e95e3aa1ba7a069578dce"
    sha256 cellar: :any_skip_relocation, ventura:        "a94f24f2b070ebc19b7dc6b0488ad2916c9b132e21590e88edd7d3d6b6ed4755"
    sha256 cellar: :any_skip_relocation, monterey:       "777958dbf09cb4741175e49f2e2959cf592292ae42dd4fc315101edfbd5452e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "147af3d64e97340b6cc0e070e7cc6f05784e6fd2924180ae555658ee724b0f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dd15889806903114df9505f2ee1b2b6e9bbae0c0675e27b55d24852697e8563"
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
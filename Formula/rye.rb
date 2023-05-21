class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://ghproxy.com/https://github.com/mitsuhiko/rye/archive/refs/tags/0.1.1.tar.gz"
  sha256 "2951176225cbd8921880d34641cf94598658a835b90db813923c0bf58319f93f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cf6d7f4334e16e10d75df1aa3d6a0b2a0ac154818c2eb2b5589ef38144014c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0e7bcb7e9e9f85a1bc3e76a465b6a8b8bfa469bd860bb9a40f85fdb36c76443"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a91b0b084021cdfffa5295693f64a5c7cd9ab97f5503e1e82eb59a917338930f"
    sha256 cellar: :any_skip_relocation, ventura:        "aa87ccb554188df6e54ea1ca4fe57950cc53b1ca53cb14f30aeafafcf716aff3"
    sha256 cellar: :any_skip_relocation, monterey:       "f060125d5ff01898038b97d63e7b5bc94e10fc41aaa4a90ee07a1e80654313e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "28b296fde38519825158866330c2e76bde2e872b1c5c0d8719cf2c304935f3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaf36cd5182d4ca39c6aa3e80490dd3b7f714605255cb2edc98a45b187394078"
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
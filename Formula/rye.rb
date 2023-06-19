class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://ghproxy.com/https://github.com/mitsuhiko/rye/archive/refs/tags/0.8.0.tar.gz"
  sha256 "3d50d066c4487e0c73ac4c3323097d2b07e3f45613cf74faf2ea900d54170235"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e652dbef8c26e616c09e9926ab9fb4184d7c5cbde619123940680e7b7d668209"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "830caf0f887f69cabe257f39cab6fa47001dc27e914f2817f5bb4a7449bf720d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "089e0b5f67eee45e1bddf560dd17e6eb1b4bccc6e9105f05252c66f9d2b8ce81"
    sha256 cellar: :any_skip_relocation, ventura:        "ca67fecbe488484c1ae7ccd82b4bde11bd4f06a8d41501aa2f833a03eee98129"
    sha256 cellar: :any_skip_relocation, monterey:       "6dcf9b0e302bfe77236c554183a1894c7400ae60600c0a07cc9420413181d061"
    sha256 cellar: :any_skip_relocation, big_sur:        "c30f04ac4ce6f6ffaa38f5e4689ac42abaaea768ea02dde2a2d73e701bd6e32b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df494676aad0a4518a858a23f7e2ab80a95e3d84dab778470a4de7b1769c2ee9"
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
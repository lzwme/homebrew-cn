class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://ghproxy.com/https://github.com/mitsuhiko/rye/archive/refs/tags/0.15.1.tar.gz"
  sha256 "a6ca07877da3ad508305ba13ea5cabb595245fc3c916a83af6903334682f94ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a5f203542513b2ba3f6800d4b6015be674ed4a7884182836520477e55aa161c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cef0e08be4c76fed48edf5c8b0d7d70c0d9894918066d4ecff9d7e31a2384d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9c2f0066692cc8e08e9bba0ed1b5164570f2ae5817670bdfc5fb08f4e8347d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "817a019b4d2ccd9175e9ef7160029aefaff0b609a559e6656af55ae209d11487"
    sha256 cellar: :any_skip_relocation, ventura:        "adb626dd415ae865d0619bd1999452bfa9a3eac2beae6e382b31592d7760e03a"
    sha256 cellar: :any_skip_relocation, monterey:       "b8088fdd7b738e0606392ce588cf2b6cf0a2f2ecd5416a118f35345f4159092d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "333d731bc6112357b1e5206865af5484df139b7568e7c524df90a667c4f767a2"
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
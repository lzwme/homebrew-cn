class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.commitsuhikoryearchiverefstags0.17.0.tar.gz"
  sha256 "fc69d04e5fd994b8862b4fa9e2971de885f07d286df64c9d2d49e40d6d1d7ddb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e62360c0918f97ffab51c7fde2645a4a667e9ff4de33ec0e6340d2e01e1d08c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f83f7dee775571365fc873a08418ebcf2ebb7f3a1ccee46107a79c860c2cdd2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "299be6ecb504af730311f32c3f879bf74fdd4dccdfa4b9dd20e80f0931e78c35"
    sha256 cellar: :any_skip_relocation, sonoma:         "97e20d2d4b05c4194fcd6ddf7f596bf6e1430b686fc99f2457360b396e8c8796"
    sha256 cellar: :any_skip_relocation, ventura:        "93ee89b0c8207b1f42701d8e78311c4b59a89ac2788b4e32615b197a5b02f1b5"
    sha256 cellar: :any_skip_relocation, monterey:       "abe6c3878cdbea7dafa3f76c41183cf69aace4696b9573f75437b95b923fbdc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "393387e4cccee2af2e8100941922fd042f46f118dc9a55aa5cfe91f4b54bb1af"
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
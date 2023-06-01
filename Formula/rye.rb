class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://ghproxy.com/https://github.com/mitsuhiko/rye/archive/refs/tags/0.5.0.tar.gz"
  sha256 "c9565638368b713a89840e6a2b2efc44ec393071758c1274b26e1f1d962ca529"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2149e94ca7561529c85e8e95f910ed632c94d64f09ba44f531e34d89d55dba6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf37e7d1a0d17503f8de8dc360fc7662732627afd9c4fb5461cb2d46a8fb2953"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "181189c64cf38728cf9a5fd26a7ecbcfb3dda466020626c39b6dc6d8c8b34259"
    sha256 cellar: :any_skip_relocation, ventura:        "548f175e4917434edf66f25a8968a8c756ede0423890b8ac5629410423e7a875"
    sha256 cellar: :any_skip_relocation, monterey:       "b4f8cc9aba51dd8535f6ba2a9ca601a839ec58550736958bb98abef7a1f52502"
    sha256 cellar: :any_skip_relocation, big_sur:        "b40dd41d5c34319382af7a1553a92cf10dc13e91d2ed9c001a91851eeb89eb1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50e9c151853325d8abc510c2543263c90473b29d132372bd8805a47e63bdc4a8"
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
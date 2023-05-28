class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://ghproxy.com/https://github.com/mitsuhiko/rye/archive/refs/tags/0.3.0.tar.gz"
  sha256 "fb14989c4cf942914c7075a15099046ee883cf8bbef860905f191f203ad8bf0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f7b2bed6f3815852b573f9c74b6f3b45223bfecc966d80a1961496f4ceb19f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4932f6ddcaa996d569f5fea470238057f31d58e27333fa5dfd87d36d3b7d9095"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22eafa28b6c146dac6dee42cd0b07b18cb53f9a82f8217edf4e0fadffcf36afd"
    sha256 cellar: :any_skip_relocation, ventura:        "e74bcac8fa171580905611059906df598be3ad1afe61151f96fac9588b3173a6"
    sha256 cellar: :any_skip_relocation, monterey:       "d8785f6e4cc208bea47962f169acaa03c324fd15d21213ee91dd8ff6274a4abe"
    sha256 cellar: :any_skip_relocation, big_sur:        "71bb7eb3e2555bdba9dd7beba3fa3fefca5da439996474da6e419a155f65d6d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5709cb89f0739db90da982d2de534a813c44b0c439811195291b6946a329cc9"
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
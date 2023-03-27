class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghproxy.com/https://github.com/PyO3/maturin/archive/refs/tags/v0.14.16.tar.gz"
  sha256 "f649ca80edbd3b9d9d9d679d7a63174de5f0c5190a57ccd258bc9e9784e3061d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69ceb74a418a83d48a24e7de7f8a4f3dbd7a686226a2e91990b486a66da85086"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99425363ec148379cc23094e63c975a942e0b0c33468b792b34229658e27ccbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92f8d97f4baf3d69ad7bbe1ab757a50fe74ca1e544f2149faa93aad2c8f654d7"
    sha256 cellar: :any_skip_relocation, ventura:        "c2b710d7cb35ff24ac40fd3356947413529b1d16b7d38336da55989e6e5e6e31"
    sha256 cellar: :any_skip_relocation, monterey:       "6d5a0091b336e973d52a938296be58994a6170e95dd4d06e4dc1fef7b9431357"
    sha256 cellar: :any_skip_relocation, big_sur:        "2617bcc1f6ef4f32f0408a53fb237fd022619d797c8a9e0020abf631d83eb788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "936622c15f4a52aae4ee9bbc826cd024f5d31d28d0a5d12624d23c409b898cea"
  end

  depends_on "python@3.11" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system python, "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
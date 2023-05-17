class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghproxy.com/https://github.com/PyO3/maturin/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "605cfe879c68295eedcf0e874676c469dab34f293d58c496ad9c99e64da9cc0e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "179a7f16e1f52819563439a9fec0035fd74e91f4a785d2c598bf2ab23936ea72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a55ea17da6f4ab0fef9ef47d6f38157f021c6018f30402d4a8a01bec191227b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47f76f79f7a24308812e63dd7c66f7d7d2e3b163f567e77b662c717c44322d46"
    sha256 cellar: :any_skip_relocation, ventura:        "4f2bf5d79385238ef869c0046513866a9cf0012674e9a21b8363f3004b9a107f"
    sha256 cellar: :any_skip_relocation, monterey:       "477e265ec7b1dd929dc3224d6b940326bd4303b741bc66da309196c7d573d6cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca66d10596173115ca2a317eca3c61eb2f60b640d8cdd87cf983df2b8a309044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a03d6eaffd5660ee3bf28bf6b1a57611aa4ce2df082a8556c28a3a1f97e73f24"
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
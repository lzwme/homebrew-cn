class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghproxy.com/https://github.com/PyO3/maturin/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "2ca7edb89db161c5c780a18bb6cc5d2f2068fba5aae085f9203daae13f86fad1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a380cb00a7040cc9fe9ded0543a17591d00de36b222c13c89e851af3503e2e0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76bf9239ac9ab7e0c64a1cac34895371122ddfd327ad7d8e29a221b091f52e03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a8b362e1b8caea7a61269b5a3054331d338ada1ed14231343814d038a3c9913"
    sha256 cellar: :any_skip_relocation, ventura:        "daeb9e19e6d236f7ababfe54f8e699a9a3286b22be194ac53d84d59dad60b5d8"
    sha256 cellar: :any_skip_relocation, monterey:       "9e1d7dc3eabe323cab10cad60b1669bcb2570576928f8dc54b4e555a81131a1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6bf4fcf100054c9dc720087670b1a8d710ec2b5619c32edab16a2440dc0d208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "357e5495e6374aa1bd3613683380126bd93bae9a05099ae8daa1fb7416c95a30"
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
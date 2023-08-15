class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghproxy.com/https://github.com/PyO3/maturin/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "caffc676ebb6c420dd2f4b7af74f3fc3189c7bcefaf9d404f52426d70f31aed9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "890c98bd62a7724853a009930b31fef1338c0cb635de2f525effe35a9bb56875"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb17c1c6cd910fd7614aeaac7fa9a5dc60d834767be9a12ce43fa07ff48b3cd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13ee948dce867a88487ef85cdd42ba008d6590999d1bc3032a069a8c3473b322"
    sha256 cellar: :any_skip_relocation, ventura:        "c76d904e12aa51eb401eca6b1aba7a7ae3478b83bd5373d50570fdb0211a44b2"
    sha256 cellar: :any_skip_relocation, monterey:       "0b01d8dbcf956861dfdd0eae52ccd131ea812a9134744cb1b160d9cbe9fd86a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8ea99cb9bdd58066849069bed19ed6864ac30f7e59b2710dd7deceb875d49f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "360d8c4102f05abd84fb30d08779b192b10dcafb4185ab7f18cbd98ce9332059"
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
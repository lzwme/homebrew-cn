class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghproxy.com/https://github.com/PyO3/maturin/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "4667478b2c44575bd4b846a7b16da25038ac7d1ff9f463158ba470a5b35c2c8a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a67ef39c11b5ad74137b43afc50e1cac85bf00f08aafb86394392fdb13a21d32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6324dfc297adcfee92ce2a003512042ac61f0bb7a5b6f8985fcfc4dc51538e7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7ccb82742728bf820dfa921305e2bd0a5767a07fc31433f5941e6cea46a68ff"
    sha256 cellar: :any_skip_relocation, ventura:        "a5cbf4417e60185eebe1b594194d6fcff8101cd303e43f9dcd7ad0a73f2c62c1"
    sha256 cellar: :any_skip_relocation, monterey:       "60d970f1effb31934372d66b5cd2bb0a52667e475a0dd411398ca3984f7722b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e78c63a633d4740c096509f141c3c3328fea05f9c6f16360dbdeeb73efa2af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80983c2e698ead33923ef3649c0fdc4dbe90f358952e48dd97f077d68b32c52d"
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
class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghproxy.com/https://github.com/PyO3/maturin/archive/refs/tags/v0.14.14.tar.gz"
  sha256 "de895e09e1cf609a0f31260b13b240d5a3530616e0ab05b7db01e7812372c2e0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7cb1781bf57a3975411db6e1ca3d8cf6fcb5fb36a4a9c511a1349221d47906b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "334d14a41bf18552308589902a2f3a2e1d8dec832aed389a580ea4715c4e605a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9339cbed60f0be095da55125f80e3d8702fe6d96df659befd1390422008ca1c9"
    sha256 cellar: :any_skip_relocation, ventura:        "b74aa2f9ff46d1a88f275cc4c480da786ba5a291a3c9facd2787cc937ed819c4"
    sha256 cellar: :any_skip_relocation, monterey:       "47cebd46a623f22331d5849288e296279d659cf6309262263814dec5015271cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ca054f8f32f7c7e48f3e2fb1353550d74e85e279f25ceff8cf90b70c6a3785a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53bd8bd56fb90785cffcdb3587ca957044bd8ba8819a6803ac8b38ff3e6db46e"
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
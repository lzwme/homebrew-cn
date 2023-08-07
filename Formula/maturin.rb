class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghproxy.com/https://github.com/PyO3/maturin/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "841df82a4b970c64fc5865ea299102d72c05eb99a650503ef133ee7f237b920c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1b81d7256e289f3893062087b3115ee1c888c1de5dcfcdf609e8b6b413569e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "770a5d4e7ce13749ae4aee8940107c8767395c5434c992215859c2c81d3b4e88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4e2e5bd6060b3f8b678c6efdbdf25d64dc9fc7099e67ec3c60454e1123f0e11"
    sha256 cellar: :any_skip_relocation, ventura:        "d63d5a842bb511747389385a09485a93dfe8a9d4971e04fcd39660c34a252090"
    sha256 cellar: :any_skip_relocation, monterey:       "d7d37ca1fc872a9af43decf850a02779e1284bd34ec24d60d6f4325ac7867eb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d4c81d3203652da42ecfb3733c5b6aa5b1025ebc1bc84e663c58c083738f75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efaaf294652e455b445514a7119ef648927a80ad84a6cc0e93482e447926f550"
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
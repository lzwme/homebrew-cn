class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/mozilla/cbindgen"
  url "https://ghproxy.com/https://github.com/mozilla/cbindgen/archive/refs/tags/v0.24.5.tar.gz"
  sha256 "0ae34b7b4fb7186407ad3eed9783a48135a7ca3f8f9e3c2966483df44815e0ac"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfb36ae83126a7f665df0ef9937b50af7e192f55fa5ef0c3d299e772177f6220"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc79e6a057cbd90fc56f9898ea678a15f8769dd3bd12d063f36b495103b6946f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c5d4d66e352912d60f00bfba39205981a0bf97e74fec50597b6d9e938b3623a"
    sha256 cellar: :any_skip_relocation, ventura:        "d0eae7379abd5e9147d4f3319e9c6bfa8ed47cd71db5456d3cce2b6b9e6d94a1"
    sha256 cellar: :any_skip_relocation, monterey:       "e104b0d29d737e3e39a9585a91fcdca423eb300e592538e39beed43c53858d6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f7c7fdabc2ada18d88e813633340db35de3eb6953662d340edef4fdf34467ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1878296f17995643b0741031f65197fe657c212b5aa842d6e3d92e2202e4c1c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/rust/extern.rs", testpath
    output = shell_output("#{bin}/cbindgen extern.rs")
    assert_match "extern int32_t foo()", output
  end
end
class IcWasm < Formula
  desc "CLI tool for performing Wasm transformations specific to ICP canisters"
  homepage "https://github.com/dfinity/ic-wasm"
  url "https://ghfast.top/https://github.com/dfinity/ic-wasm/archive/refs/tags/0.11.0.tar.gz"
  sha256 "5abe32285ff6b652942ac363802350b69fdca47757b245e05e44e810fd7017eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f7b31f0459e8eb15aa68456e13b5f9eef9aca3d344b5cf2acb2ce9cab9e7784"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec2ff204ac70dd01f2942ad42a51237710aac02111406b4aca3a5d2a2af3841f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "037b8cafb1bd0ee0232d6e9735e014b6495ebc322883f1b000125ffaca1eca13"
    sha256 cellar: :any_skip_relocation, sonoma:        "273a4d56acc9fc63641bfcbb7e986edbcff8388b507e1b0f6878b26581b9c6c6"
    sha256 cellar: :any,                 arm64_linux:   "cbbf9685297c1c9d06f9d6f20a60d8ce1ef0e944333e9eb6955b7ae8574843af"
    sha256 cellar: :any,                 x86_64_linux:  "fcf5456f9490f238f5257d08f1e30d7d6a9f3213b2eee47b3c442bd7e65ffe68"
  end

  depends_on "rust" => :build
  depends_on "wasm-tools" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Create a wasm module with a custom section for ICP metadata
    (testpath/"test.wat").write '(module (@custom "icp:public abc" "def"))'
    system "wasm-tools", "parse", "test.wat", "-o", "test.wasm"

    # Verify ic-wasm can read the metadata
    assert_equal "def", shell_output("#{bin}/ic-wasm test.wasm metadata abc").strip
  end
end
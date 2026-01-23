class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.88.tar.gz"
  sha256 "5d32495882d113d9afd0ab1e0f34bc226e395bf17a1320cb2ecfa0d7fa46bcfa"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "987f6f917f29040d83ee20e964a57c96960424d6dee9b12c4bfe892363eec383"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6975c98a1d00c00046033c3d8c8b7b60851da32f625ccf522ea060bf29677824"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c34130f6c66c22203e4ee89b2f52a7aa934b24e5cd769fe5eb0ec37f66b3a030"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ed4859913a58dd21a057a255e627e3ce077932f1d1a467f56a9f79f3d5bc298"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f910702390d27d0ccc28f561f059e593d276be981c7a5d15366d33a7980a0f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "903ecf5d3569750ee209ec3d0576dae13002756ae72ab99fd3dd1469c7d3adb8"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
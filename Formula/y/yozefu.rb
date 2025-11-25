class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://ghfast.top/https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "e4f83830e34e3e2e79af23aa80985cd0037b8cfb478566ab1cd0c38678b49d19"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4aca973cb8ae3b414f6566802be62d506ed9bdc74aed50905a839d7868a84e63"
    sha256 cellar: :any,                 arm64_sequoia: "8c043bfa1ed8b87ee87add5344528cda584ce625bcb962c18142004cbd1c8f87"
    sha256 cellar: :any,                 arm64_sonoma:  "3457208c350d98e7047afc84f5ca0a6bcd178126d49a418a87fc92c48ae9b1c0"
    sha256 cellar: :any,                 sonoma:        "3bf70428a5e217afad071b056d519ffd41db34215071c3f5a3184ef0b5dc4ad5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44a03d79cd1fcd2aadf0cede7eae961d0e838a7efd42185a9f0d59bd92185f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d511c8a11cb8b6a3c90db2a40780493055a4a93163bfa662aba44851e36d6c23"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/yozf --version")

    output = shell_output("#{bin}/yozf config get a 2>&1", 1)
    assert_match "Error: There is no 'a' property in the config file", output

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"yozf", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
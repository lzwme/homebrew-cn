class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://maif.github.io/yozefu/"
  url "https://ghfast.top/https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "c6875a2ac1e4dfffcd111af3297f2e648e25ca9eb0062ac08f01e60c8d88f80a"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "dcd47959836257e51dda7c34a7b64605132c6ce4cf946256d081275e5595f667"
    sha256 cellar: :any, arm64_sequoia: "f71013a27328852c9eeeac70e5f5b487fd502a92c63a624b21df691c7724bdcf"
    sha256 cellar: :any, arm64_sonoma:  "362d83e23d856ec8861fb5df885e4dde196d3e21772a268b203104d1e37696fc"
    sha256 cellar: :any, sonoma:        "06b2b8223a7f8f70f97099260915f7c29974d037ce5e0d9f4989e94501ab7cfc"
    sha256 cellar: :any, arm64_linux:   "3062b1a03a0a3864ff3b111db07632303a14d3530cacaa06ea27669c05eaa143"
    sha256 cellar: :any, x86_64_linux:  "5b76e09ff030d1dfb692b91402dc9853b3f73c105bffeee099051ed94cfd0da7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/yozf --version")

    output = shell_output("#{bin}/yozf config get a 2>&1", 1)
    assert_match "Error: There is no 'a' property in the config file", output

    [
      formula_opt_lib("openssl@3")/shared_library("libssl"),
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"yozf", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
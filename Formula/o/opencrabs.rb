class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://ghfast.top/https://github.com/adolfousier/opencrabs/archive/refs/tags/v0.3.80.tar.gz"
  sha256 "733b5eecc2add6bef15103c7e5f625f3eaa82357dd71aa9e4b483c17f54eb47a"
  license "MIT"
  head "https://github.com/adolfousier/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3452e3783b00bb680a25e4a92f76185d5714ac10aeef4e7b666eb2f5eacb274b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e6c15ceb9bf2f070c026fc9c63e01967eba338bbed5795a7ee3c09f0299fc6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f0a483a54e1a2d5d241c85aac2d594c7cd1d37839a08820efcea10b08e92a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a3786d181e661d94e07d9b8f1d70acb0f16ccb331bf3bdb0542e469cac8b9f9"
    sha256 cellar: :any,                 arm64_linux:   "af4c19b4968bbb73c7bacad40e0451f7d5eeafaf04aefd68da5b5f6193511c4d"
    sha256 cellar: :any,                 x86_64_linux:  "d0cf05a8970e1759c28ca165d6cb94a3c51f164882b16faccaf85c48b27cdaf3"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rtk"

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"opencrabs", "init"

    config = testpath/".opencrabs/config.toml"
    assert_path_exists config
    assert_match "[provider_registry]", config.read

    assert_match "Database:", shell_output("#{bin}/opencrabs config")
  end
end
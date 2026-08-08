class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://ghfast.top/https://github.com/adolfousier/opencrabs/archive/refs/tags/v0.3.79.tar.gz"
  sha256 "5d76428b4894f44d07c5f11a66261be3d374d00e6ee37245d128cfd7bf845c41"
  license "MIT"
  head "https://github.com/adolfousier/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed77506142e394ec8dac378f58c056aaaf7cee526564af10c065094ab576d2e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "050fc794e1f5d28a22c1ab9e9ef5a7b877e0197aaf3d853fc05ed2182f8d94cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "750e48b742dd766d1a4e571252ef19ce791d63ee621baa240a86119618be4f1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e7ce9fd4c1ff519083e8b59309bb7edc0ef8d325ffb245b8a3831deb7ace1c5"
    sha256 cellar: :any,                 arm64_linux:   "0592687483e525df04833894a9bec2bb1addaf7d7603b80b6527b31317bea5b4"
    sha256 cellar: :any,                 x86_64_linux:  "7a9fe34d2fc768537cbbb1ffd9950f63cc9705c40f1cedc275c8773c30f64bd3"
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
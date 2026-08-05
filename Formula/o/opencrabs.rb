class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://ghfast.top/https://github.com/adolfousier/opencrabs/archive/refs/tags/v0.3.78.tar.gz"
  sha256 "1ced91fe756beb7b09764bd3c8864014f07bd04b5471e0f2aa82c29996744570"
  license "MIT"
  head "https://github.com/adolfousier/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f098cfc65e1ff41ceb67e7261ff1d481b31cfd55a07b8527633f0310c89bc35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "970679649163faf419982d23d1d82556343e38f4a351ae64caa047f5487f139e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f1b44017a6b340df6b8eb3f73e3ed096b498ab549ef898b5401b4671f81a72c"
    sha256 cellar: :any_skip_relocation, sonoma:        "840450f77b056f042792bf821b74475e02672f8b314aa1eba84eba2121957f77"
    sha256 cellar: :any,                 arm64_linux:   "65bdc5432d87a0ed8d32d7a4f0c0786051cda1ca3cb49691d7fc4b0bdd419ad0"
    sha256 cellar: :any,                 x86_64_linux:  "9d6887627934e9a805e2832c06ab9eee7d2966804459e7bb5baf210fc6ba021f"
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
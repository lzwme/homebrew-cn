class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://ghfast.top/https://github.com/adolfousier/opencrabs/archive/refs/tags/v0.3.81.tar.gz"
  sha256 "b863fbe0634abebee714f1bf6ec54b0db6a5e52972a0988a99f9d5b93565f281"
  license "MIT"
  head "https://github.com/adolfousier/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dff95921ceae16e97bb823ba8598bbf3ed122298190dc93e8a67cd47869b8920"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e1cc4245b562127661d911062d7461d1f3daea5aab89d9acf2e8e43387943e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9f25797b2c0b19ea1001c4dd56f33d8633df67580ca62320acb7bc9f2ce412e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0513ecbbdd9958b2edf3ba27d93d61ca3281602231e23201931be5cc3205ba4d"
    sha256 cellar: :any,                 arm64_linux:   "aa16df276618c0b1433f0adbb358691dfaf6078d2b7d019ef33c2c444c82b8b0"
    sha256 cellar: :any,                 x86_64_linux:  "5fcba94c8969e0042c787f6a7fb552b218af18ae079b06947be2c864b559927f"
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
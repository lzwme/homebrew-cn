class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/2.55.0.tar.gz"
  sha256 "2d73a2b615faac643dc1cafbc89351de0155a3db8b1506aabaad08000042d7e9"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abbb01df7e26ca1bc45b1dec2af9f2803ef71cbd3519af783a8feb3550d43129"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b6bb6e0f12c114b39ebdda77aceb174326523d5d690f668d15e65749130dc5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "853e747e4345b504b62f11982ec88265668540b8d4a5f28d2cc06741e8b6e7a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b347d2d1826052b2205dd1760f5b71a1015be88f3d090d227b7a92835a402b2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b14c88205f835964142d82c202e9a4f1489ebbf9133ec1f2ac078e66aac5a038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f774880c9b95fc8bc619fece973955971f0ee111a1857a560f2b1bc739ffcdf9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on "swift" => :build
  end

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["SWIFT_DISABLE_SANDBOX"] = "1"
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sentry-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sentry-cli --version")

    output = shell_output("#{bin}/sentry-cli info 2>&1", 1)
    assert_match "Sentry Server: https://sentry.io", output
    assert_match "Auth token is required for this request.", output
  end
end
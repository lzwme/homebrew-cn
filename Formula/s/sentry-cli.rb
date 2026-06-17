class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/3.5.1.tar.gz"
  sha256 "ca12d6b5271bf1afbc451fc8bda1e1e768895a7875e94aa740ae16f32eb7d66c"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f60287143eec553d760d77100052910cdfc0764b4d36603bf9c9b8b2fbcac9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff064dae8b35cda9845bc5c73a8752a22a917b008c69cb51d4c43e7bec2e6e9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6feefb9a5c6020dcb7b71d0a7194198cd8ea14475a8013b294b727d75c9d4cac"
    sha256 cellar: :any_skip_relocation, sonoma:        "22dba6d0df8733f06f99393badae213ff5cfe8455905dca2507232f581514c16"
    sha256 cellar: :any,                 arm64_linux:   "f07fa79a74a46446cc5e6a13f9399774d333aabe5c4fc35ac75054d657fe1f61"
    sha256 cellar: :any,                 x86_64_linux:  "c3e9eda5f1b7e11e63a90efeea2ad1e5a7e67092f1ef53c29779296c3620c88d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "swift" => :build, since: :sonoma
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
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
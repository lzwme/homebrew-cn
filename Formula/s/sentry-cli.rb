class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/3.3.2.tar.gz"
  sha256 "e7077589f724564c78e654fbc070c2732409b0d7905b58314044b5151f038e70"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1899623fd932310b80e607dc776c3fc60af94ec1ab99e5d889127a44bdb03723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97f280ad12a9e0941f9dc476bac55677168521aa6c6fcb60cc7b65f2165f7082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b27701434fcb0e13ee90f604e2a03af863f764a741322bbbc91fbf347c31ca35"
    sha256 cellar: :any_skip_relocation, sonoma:        "0feac61e6829a2e38b5677b8b981cbd40d20cd398d6240dd8c08e3809dee68c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef3c670ddd9c8e52bd111952bb2750f5c2f20b095c007bc228f6b4a13adf565a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "168efdf6688d9240b807d6e424acc67ee544fff474101eabc0f2d74ba8004273"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  on_ventura :or_older do
    depends_on "swift" => :build
  end

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
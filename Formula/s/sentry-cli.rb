class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/2.52.0.tar.gz"
  sha256 "bb83bcf06b8ceed80e9f760964e3f558adccff3e5694002af4c0b836512e41fd"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78027ed9d55839a23a9dd5c797da95ffc3129ee4216f9a6ba4a7fb680b2ab34a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0aede98e7cd4b5b397f8324701113aeb0d6f5e17ca1f1daf5d36d09bfb080c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3d1f542d6e7ab8b73e1deefe37b7860f4bb7c974a0babe1d544e93b9ca9f2db"
    sha256 cellar: :any_skip_relocation, sonoma:        "47883ea54a8025b20f2bea3b4b852828c8122feb633e4ad25099ff9da53328d5"
    sha256 cellar: :any_skip_relocation, ventura:       "25a515cbb8ba528a39094338ea80c06b5afd6807dc3185d1bfd49b76c6ce362f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0358e0bfc1c7aace5f0ba91cd336c630b5dd216ef919b5bac48de865eb34080b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23a78908ec9590fcd562fd8d91094dab175f9b954ff40a4ac9002c1a93bc1d0b"
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
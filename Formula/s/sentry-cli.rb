class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https:docs.sentry.iocli"
  url "https:github.comgetsentrysentry-cliarchiverefstags2.42.5.tar.gz"
  sha256 "d894ec10dd88700f1c8656cf8db4d486f60ab4bcca8dd924bd62e115d3f37d4a"
  license "BSD-3-Clause"
  head "https:github.comgetsentrysentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18d4ff6ec1354f7a67f38037ec186faca27901725326ebcc393078e3ef52a4af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcf44b15e9bc4255eae40ca3d3752b9d9f1b66b74d035a1749176aea590998c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4c9cdc376a2f7d63854a9a2c7c3e73dc1e34fb33b3b42f69993906124b3910b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0223272289553e9cb3a6b6e714cc2ad8cc6ef0f6ad92984d0fe43ac5c1f56aa0"
    sha256 cellar: :any_skip_relocation, ventura:       "a54baba2ef48b5365d081abb4bcbc1a8da2e6bf9c45832008efce9d6f9edf435"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de1f64a738ee371ff48a8afef2408c4704a29192735692096ef2ce237b34c979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4f4da5175d4c50f062549d41b879621201696d639cfc5027ca35a4b6bde2ffc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"sentry-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sentry-cli --version")

    output = shell_output("#{bin}sentry-cli info 2>&1", 1)
    assert_match "Sentry Server: https:sentry.io", output
    assert_match "Auth token is required for this request.", output
  end
end
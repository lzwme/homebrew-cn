class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https:docs.sentry.iocli"
  url "https:github.comgetsentrysentry-cliarchiverefstags2.42.3.tar.gz"
  sha256 "6f8e1fd9ab7194a6d14b5d192482a742d030fc022a0cb1253d3d013a413291ec"
  license "BSD-3-Clause"
  head "https:github.comgetsentrysentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a13c7e949a6ea37b7d6833b5379d0081d71a0b314c9ea23a0a49c4e543abfa85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16dd5b91e64b0cd940d2fdeb930215e9ebbb0de960da29038e9201b9806e9817"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0af28d357b288dd02b5e0e01df29de0243323e67f66cc3845ed2765dccac295"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f0abe436c40368f9b60e4b665ebffc221636236bca015ccc5d9f9b689b310c0"
    sha256 cellar: :any_skip_relocation, ventura:       "364a14e7c6ce33ec204ff15cfa806020db6004fe5be445b4e9bd562e6f99bced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "199b909808330da633f2531608f6583754cb41d49467e778a9d3f49beab862b7"
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
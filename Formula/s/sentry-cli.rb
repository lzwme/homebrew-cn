class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https:docs.sentry.iocli"
  url "https:github.comgetsentrysentry-cliarchiverefstags2.42.2.tar.gz"
  sha256 "847c8a88547af396120dc19df14a433148851f5d3567b6b8c3657cb209034957"
  license "BSD-3-Clause"
  head "https:github.comgetsentrysentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58013463cee50a5a4c59882bb4a31fad2671a90da1e5cc116f3c73a749353f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c27a8ec8b55817aa74add0c6a3942c196d1527fb84607182fe31f6f14e0450d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03994b473c0804dda6d60950494d2bb7d3b706fe09d0946987e9e42458e939dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e898705822f3d143977a1a13e3040e9da91ec04a2ce7b6591f5f78c6ca867e3e"
    sha256 cellar: :any_skip_relocation, ventura:       "b00d6ad23a6d6c4888117c7e4dc240975a534f474b87c719a6921fbd2551b3f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b4a9407cc4d4c99204228237ec1120d5bc2675075cadd926bcf55c5f35addd1"
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
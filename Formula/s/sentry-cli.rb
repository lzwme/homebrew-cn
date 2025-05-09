class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https:docs.sentry.iocli"
  url "https:github.comgetsentrysentry-cliarchiverefstags2.45.0.tar.gz"
  sha256 "c83b42079e38d1a1fc9696adac278d36bc604c41d5fd5c2c1f7692729022ca51"
  license "BSD-3-Clause"
  head "https:github.comgetsentrysentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0531da10742174f8fe4f361683388014af1cb3f385143cccceffed404c0624e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "386f184952454934a6632022dc2be024b3421a6574ed8d1243441e2d5de884df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03192423b4aaf5243a965a85be32ddb7620bd94a04d4495296a10742a2aa6c77"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e64b1cb0e39a166935fb012a15837a509894a3b493b518a84c320faab982437"
    sha256 cellar: :any_skip_relocation, ventura:       "def424a22fb4be0212fab93ae3f5e326b3277b4c1c6a51a5603bfcce7c083f0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce2ab090c71ad89c209e98e5b997e1e43080219dec97aaa98322f445bc411813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16fe9a34b877aed1d123e4f750711312314019b61520da134ec4ef0e32a4efe8"
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
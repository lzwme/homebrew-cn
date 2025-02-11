class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.27.0.tar.gz"
  sha256 "3cb50700b7d9e6eaaf118b95e12e2a6508a762e08d37befbd40b524107dc6555"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "938a260bc0a03c770ed44ffe13b6d4db9516ef403eaeb7f3df2c0a6c8d8984c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "742483ba7db4f46ce9f4353fc8cab31dd19911197a9f939d8a879b1fec8fdf6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c51f2d5b5e4f57f07c189d70b5b4e77a9abf94ae21dbd8c8012f2d85ac26d9a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae7b91fc2db0b3d703f01182d97f2113daccf9a29aedbeed60c8cf5ff6a4172d"
    sha256 cellar: :any_skip_relocation, ventura:       "a203a2f044f54adaa2f4db641b22a8b8bca0da98faa4f4a59ce35ed4a6128fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87c136a1b87be631e7c434754c014a4c9886cc968e9f4471b0268eb3ccadbd1c"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}rover graph introspect https:graphqlzero.almansi.meapi")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}rover --version")
  end
end
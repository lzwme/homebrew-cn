class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.31.0.tar.gz"
  sha256 "82c698bfe2b5f3c10e952f3294bf0a154b79d5410f0521c6fb02c91a0397c0cf"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a300c50b001b528d13e56cd5deb7f2d22272052167e6f2ae4ec4c322afbaea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17ef8408ca0918c4a820678eae928f01aa9ea39b51a83b36db303022c6f14a6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "814230307664a5a6020345cce0a068a6b618656f87f677752c6a696123bbca2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "74cb899d27c528e865abdc2e76cdee2f85fbc9a97c2cac787cb098530361c778"
    sha256 cellar: :any_skip_relocation, ventura:       "8b544426dd837e23c0569eec0d3c2f7b67a47f27a96067f3cdcdb62ef2204312"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26f25de0bab67a443f0567e197dbe08594364e9b7c18a246354cc222d89a90f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c4d7716d0a85e54d5e98b882f611ba8339f43bf793afe167943bc48d3667abd"
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
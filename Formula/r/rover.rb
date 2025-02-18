class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.27.1.tar.gz"
  sha256 "b760be27c8a93eabb08e037c91bec65506b40f5011c7ba9c957f5369430520e1"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "560da5cb564f28fbb455d4d240f16c407658549bacce86c2b55ee166bba88623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d112724dc103ed4caabb04d287fb34461457837016a0d868de796e5a0d80b725"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a10827ada169af7eaf817f7a33eace78a9962a7d8e8b5d499085f92c48ef4e24"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e3f87383427f8cfae83e5dcb190b6c634c8c3b3a94a56fe2b64264ca814d539"
    sha256 cellar: :any_skip_relocation, ventura:       "fc32576568edb47251c74224021fe2e4cf35544d7556478adf77a5d7c538c06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb47fd227422435beb71be1bdf76cf684bece2b8a56ad78b22a2fb081634f37d"
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
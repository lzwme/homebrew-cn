class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.28.0.tar.gz"
  sha256 "2dd9e43ae166147dc687a026464ceecce261b87d78a6bdb199f0155c6e152ae6"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3727e11322747407187c2421227c529373daed0f5b823888441dfa3877a9190f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff5d3c1503d47b5285ae6e5c000209c62b292ae3da7ceb5c2226920970c43580"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "244a27dfab5c0e5899bec0e58f43dba5fef7046220526af77034e93a671c0a85"
    sha256 cellar: :any_skip_relocation, sonoma:        "3aee76c0cb21cfb144d42babdab7ad061b02edbe9b84fec174edef70d4c1fe38"
    sha256 cellar: :any_skip_relocation, ventura:       "a08a3b43008300af9164dd33daa01b9b17f0e187c3186b3909c0b6bf407221a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2192bb86611728b5fcac517da12db68d4d7f031f616203bbaf83abeae9059bbc"
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
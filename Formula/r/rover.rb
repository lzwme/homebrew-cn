class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://ghproxy.com/https://github.com/apollographql/rover/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "19c22b9517fdc26adc90a04de6258b5aedaaade04a38c98eee00443dafcf71d2"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f5abe4ad42a3f72b8eb2951a02f144be86d6ca15195bf845d51330edf144b7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4ff74b85c997505edf78e6469a7b6ea8243149533a6094b4d584a33ac52096f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f483f1c96d8e7d7e7555df85d6542bac750f4fffa99a89db5e98635f91327aa1"
    sha256 cellar: :any_skip_relocation, ventura:        "e30c2ca6af739804530ce8157e3fb92417cf88286e09836a774e442cb21aa0a1"
    sha256 cellar: :any_skip_relocation, monterey:       "b5975372bdc3833741ceb341471c4550804dec0628b9081ad15018a47033dfd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "56efe287ce58eae9d9cda59cf945fd9dfbc64a53fa777808724daf7914fde3a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70bb17ae04041591d0a096fc22949c06f030e09749de92478b00f28e7a163cf7"
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
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
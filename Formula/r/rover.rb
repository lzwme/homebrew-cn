class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.33.0.tar.gz"
  sha256 "7663a4a7d2cd3321174de935a6c722b945229f1c92418ecafce3ea52b2c8e0df"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2719acdd9c4ce54aca611df35657e54679eae5171c5027c6bd301afb15f9ec1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7715772c85f5812fadc7dcb72fdba078553bea75927e3d4a66bee6d2f71e768"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d981dbeae588dd14509a4534ac29ad68b081cc00e6ae5983249686210fa29eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c833e67ba9fe13ceeb630811123fc7588cf8e2b64407f93bed07a417d87cb5d"
    sha256 cellar: :any_skip_relocation, ventura:       "7c7e3da3b9c44a698cbaa3c6ce033421d4cf6f8c482517b55eaf38932093daa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b925825710c3957d9d951b70c3edb371ef5cd48ac29e4be0fb9887dde474f3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb0a47d31665bd732254eda3194e363a366124e6e58c366e68e0719d549aa9a7"
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
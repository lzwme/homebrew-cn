class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://ghfast.top/https://github.com/apollographql/rover/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "fd21c6525bab9b3ee05094f9767040f6057ba3f04749a9a408288655d030ada7"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42f435cc83a840f0ae81e8c6ea83c5c8ee57440ba598d6ec792fe100d673f1ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0d12e28267b9a21a053c9b34363d1db0ee625f9d5324adcb941009ed1b6b5cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1a8a2d1e74d93ffd1d52cde3cb20c1e56348f5ffd19938b640a968a5e2c52b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d27698712c94f3b1e09a1392876d2736bb75360073b57c8a71bb3e2c45a2331"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2579df6f80bee6b7f65ed17ef4c12e89628bd57c1c5b9652f60a52a63c90b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "995cede7fbb0b6914ca6d18d6f33951050fead6f0d326a9377142c3584170dd7"
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
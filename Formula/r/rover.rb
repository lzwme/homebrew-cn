class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.29.0.tar.gz"
  sha256 "c178bfff295d89261374323b7fd2d1e5d5c3a82ae0ec84792ce4107388f06f8a"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1700590ce704e16826e59033784f5a6a8be923fb7a736060a5826ea828c4e2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94974bcd4563ad7724e372be648f79f6257f58eec082b40127d884165a1cc02b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "819404fd2354d3de79b39d2cc298995e23f4d119f9831711895ca1548231efe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "43ade99e931296cf9e5084df1907fc9c351a263305398d1a90643e6e376011cc"
    sha256 cellar: :any_skip_relocation, ventura:       "35e8513ff826a9ec2f0a757e64658141e6f3d7f5647338c8855549b52ba1fa49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c6972b02d0b03c08e0df99ee9ba95a629e829f71b2595a484a6c19b1370731b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf60ddbf0b3ecf1baf1336e199a41e569297ae013e6dfd0be22e712edbd3aec9"
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
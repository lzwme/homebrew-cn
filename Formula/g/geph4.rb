class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://ghproxy.com/https://github.com/geph-official/geph4-client/archive/refs/tags/v4.9.9.tar.gz"
  sha256 "8749be312db244df10bf680c76d571eb86502c7fef441d1ee12abfca27244d7a"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c4bc9ce7c81a03325c92c59ebcf92d141226145c31e89bd53711eee9e30da70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0abedb1fd6b847394329ebfcdc110ebc03eba3c4c94f6172e8c00c5be4605927"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c58531dd767a0b5d48e74124e2c1491b895e6092a8a2d7d2b7ae36432f6f94"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec152ae6a13a2f2a8810b52d3ee8181817398d0e2226ba501aa23cffc21c2255"
    sha256 cellar: :any_skip_relocation, ventura:        "51e9fa5149412fd04f8550ac846802d77a3c56ba976f309d65b136840e02fd0d"
    sha256 cellar: :any_skip_relocation, monterey:       "088cc89013c139f37d500c511df3f05eb04bba18058eb204b3c273b2cb062de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4b23e4eb804f01b60fd72cdb4baf7848f4c5f5e366bc604bcc97f35e55baf67"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
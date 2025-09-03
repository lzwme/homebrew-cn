class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://ghfast.top/https://github.com/sysid/bkmr/archive/refs/tags/v6.2.2.tar.gz"
  sha256 "d71572679f7e416c03aeb467498aeaee75065b8b9fcf745ad64c59556af7cf19"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0287e9f7aa6391635d9251c65a1220b4a819a391136dc29d7987f5c81adeb2d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b48bd07f3cb849498493b9b627e54caaa9a718ff3529cad5030ea49f40b96cb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d580abfbc4680785cab2ca86f5e3579ac827ef8b88936c7d0bc9874ada6a0590"
    sha256 cellar: :any_skip_relocation, sonoma:        "d339f9224dc99f616f51d278f59e9a0544b1805ca2607bda7249bfd7e872bff3"
    sha256 cellar: :any_skip_relocation, ventura:       "37843b373482319c715861f4a4ad68daef9f2ed2f014583d82509132a43ca647"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2854567d14f43056d6e86f621326ca5266fb165be5760973f94a0c3a3a69c1e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eedb372086c51611487c0151f5e03d711d599cac7a0865a29f95209678a6df3"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
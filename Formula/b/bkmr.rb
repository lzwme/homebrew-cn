class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.20.4.tar.gz"
  sha256 "8beb4da02309cb781e0c9f1dd2a1df38b2f89abfdae81ba27fdbfa54f092b4a8"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d391c21d9fb14127abfc7e740d6842eef38c81f5c9695ab5df67ab707c16c64b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe446d8e55a4fec6c60b3cc518638b96f844b717d2517f7603b4fbabffb66e09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a614911f096111f2524d5ba448b3c4ebe1b3b1bde8e55d5fc8b4e3040efb2d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a0fa7b2b74bfb38f290cd1bbff32553896b9cf356bb07265da0340556f92538"
    sha256 cellar: :any_skip_relocation, ventura:       "c3d1773ec8b8135289e95958a4502f6bda09f18eda8e968f0c58af0e9bea36b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17ff85f2de965a10e0be485242595d1f7efdc95e41a844b235ac018ada2755fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6546563b3606040207796bb063a01a7d09c3fc6566951e9cdeeb12594d042b67"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https:docs.rsopenssllatestopenssl#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}bkmr --version")

    output = shell_output("#{bin}bkmr info")
    assert_match "Database URL: #{testpath}.configbkmrbkmr.db", output
    assert_match "Database Statistics", output
  end
end
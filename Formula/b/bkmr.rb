class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.28.1.tar.gz"
  sha256 "eae7ebfd2d02bbb04203a27f474867c08d4cb6dd82acaa06acd676a5f156d7a7"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2081b4809b68e2642ec79386ee623b20ee6e098ab966ab36e1d7ef1662faad8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9011c774d5082ea611094e652b7401631051944b90e77d163d679f31b87ee702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95cb08a04d3fb5748216e67c2b210547fc742ef464fd0953678b8d76323b20fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d4ca5ae31d9484b8fd6ef6d4a293ef12df0a96c04bff5f03ea5467be8b070ab"
    sha256 cellar: :any_skip_relocation, ventura:       "f8c39edc4338cc0e36921fa4e172bca02dedecb2cf03328368f4da87e0e69f67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9819031d57ab507e3907e7721574f6a71b89cc8af019b1243a07ac6b8acf7148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee2a71e31d82cc34dd2e28fcf00b1b240b8a90569198ea2ecf722f778168b7f9"
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
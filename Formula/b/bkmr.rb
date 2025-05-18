class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.23.2.tar.gz"
  sha256 "6d57aee51b27ad7b809420e2af33f548d22ba6e4d0f13b8944b36f6951478f47"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "030f74656067396af308d200a1db7c149dfa7769a66e9807cb4f04836aceebab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93a2a6906f9c83505cf6c4a50885258979627d233d2221449c17ba33af617363"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13d361a87ac363262969ae6647a377df4d2f4c24101277a3c7d62c6ccea8dc22"
    sha256 cellar: :any_skip_relocation, sonoma:        "2974feacd0d3fe4bcc79321d6b986ccefb65fb302e10d932a2f13682f04ba003"
    sha256 cellar: :any_skip_relocation, ventura:       "d4992c566326f379c681d23a90bb456e4326f089ade7ae903c37cd93b9abf23d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a220c88430d8bc2d5b497f3f72e2434479ec68cd97f8f16a8a42d4856efad05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab0a5e5e534d7532b87a9d984ec817f82b89720d2ff7ec80380ba84722b6287f"
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
class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.25.1.tar.gz"
  sha256 "329cb6e797e448e1f4f7e3545071d7db0a0fe68791982ae945787d0fc3d28c93"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1778e1fe94b041203e86798c1341ce38d9a74eab6a9447ab783330f62f800ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c866e567ecfc5452d8cebc4494ad0ddaca7d754545f706477c46ab95afd2e81c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c84da01f0b56a2b8afa0923d43631f2e5d6ad965357579272877b0a53a6d9ada"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe0d73db2df7927f055c149b167ef803bce02515f65c3b2d8c824359ab4c8b16"
    sha256 cellar: :any_skip_relocation, ventura:       "a4c631580a023e44aa85e0613462a615efb799cf14887117697d3fe46a36367a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06b472ffd80c417e66a40a0eb9c606b02ebeb868cc9706ae66ec5bcaa180158d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef55f6c724947ed133a613aebc598bc4c3727ac30d2cc7884366560315c4535b"
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
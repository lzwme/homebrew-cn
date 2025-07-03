class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.28.3.tar.gz"
  sha256 "3be293b3efa2d738efddddccb675cfb6b82b08f11962285735d755f1fcc302fe"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "415d28c6d75e7d0dd775c0942f8612a4500a922ec50b5285e7836d8e90d6436d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c4c213e396e5b6a21242b7c1ad2e831795c82e16ea9215d8fd8bebea170ec40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bb2f4a4aaba745de4cd66a75749e5cbaa7937a0e37ac6532b1fd5aceed87bde"
    sha256 cellar: :any_skip_relocation, sonoma:        "4627e5cbf563bd420efddef29043956f8e66cd105866ae4970c6efa980733f83"
    sha256 cellar: :any_skip_relocation, ventura:       "b91bd1476e4498403f04f57668ed2c56a532256a6e8f8cd1bb875d94619fb0ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf74552dc339f288a1fd70c9386d8291a7e51055705e03c1019a6e5a5339414e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56c342a25d16cf057e2cbd266c6f3522b65a9e79df5ded6a82123b473d3e378f"
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
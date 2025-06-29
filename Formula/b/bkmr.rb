class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.27.0.tar.gz"
  sha256 "70df5ff39e59087e75823e540293eeb587b6cc70bbc7ed26ca44f48af01faf44"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be864c56ce4c96f96e14f9eca226bae1e2f1ecc58f02f3abb88d006e5215a8ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d27ca7927e9b8e49b4d71f6636c987289f9886424906959447b4df671b222f62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9a6d91c1d8c9540837889ac50e19474b9841782a6019a04de76631b5dcf8c27"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5ac84b676e23fff6c29a05bc8c3cee5a719498b20098f05d5d3331783dffa96"
    sha256 cellar: :any_skip_relocation, ventura:       "be6bd231b7ef967ba071a603f7c47ee23771d0368e5df5f54b4ff8164322af85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d537f2508355ed2ef726a070ac934bb9df3ecfd53f5ea0584b4ac15e7b40886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b8082f9542a51575301742c9707cf4045a6eff16ebc549944c6386000d64f63"
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
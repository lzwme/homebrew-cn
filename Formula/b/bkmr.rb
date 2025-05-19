class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.23.6.tar.gz"
  sha256 "f0566017c0e91618572abe871ee64a2c0212d925004e45612dd3628761fa6afd"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adead50c223e6833ac096274dcb27e138bae8bb0f41bf4027b19de3cdaeef073"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc90f728a0bb25e9dc0503dcf4037ecf8455cd1e89b81473d9b739314c1d857d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b4e6d1b512fd5f46f8deeefd4a4ab31fb27595d8f99820ef2b78198562125f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "45eec6cd6e6ce125e3abe7cebc2730367b570575c68aa969db78b58a0d86a2c3"
    sha256 cellar: :any_skip_relocation, ventura:       "fc2626afd8c992e22c9ebbfe3398883802f9607278d9bc9433a48d2cf11ce135"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c8a68b3dcf3947cdfa7d450e39e490f1946100d074c4ce40c01e7cfda64ddf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aecf2678e02fbf824194692e61acbd107fce643f0c785cf8e7dbd1bac032e5e"
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
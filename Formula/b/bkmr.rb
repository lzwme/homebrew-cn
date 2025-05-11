class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.21.3.tar.gz"
  sha256 "1566dc703ec500efe11028e45904952e3f6c6e6daffb15fc84d7e8a3fc3e36e6"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eece03b8fdfbf998c5b6fa34404db71137baf585f1e3673c9b30029baacdad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3418423b456b8be2af7bf63de8180adb41a76d2cc4aac97fb6e491bcadcad75b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc7b1b1b11a0a5fda8711e9107a24eb66fa918c59c4594cc7938d81fa10d649d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3860c732d974c3afc326d0e607b6d85976151ef954ab05179d33b3922405f283"
    sha256 cellar: :any_skip_relocation, ventura:       "5496b10cca26c85c90671193d5238fe2234054d915f4db1a3ece1397e02e29b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6bac12c7ba573a72b9a7e3b769d77866291fdb369408e9a6c7dce7dfeb0270d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36201b543cd529f86a830c62d56a188331b68e0a53179d93027f1b38d466697b"
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
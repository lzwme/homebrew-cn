class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.26.1.tar.gz"
  sha256 "60bf6d34a7a87bf903b095a1c5f0d2f150f12fb9fef3977be48caab4ff93858b"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b3cf9ecdb1bd9032a480e66401760450717998dec2feb20b8847a289a2b8933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5eab3ea484c9c17f85254e27e4230dfb020bb546be9c2348c6d2c8f966633de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c8ea204a11cbd859d25a059a8e1b32469f578ca1dbca7cb789e167c65ef0847"
    sha256 cellar: :any_skip_relocation, sonoma:        "52937fa14cb06772457584240047d51c158152e2b850b5cd19ee81a5eca26047"
    sha256 cellar: :any_skip_relocation, ventura:       "8e337cc590bd177e4af9c15e9ca2ed8b2a14068699a454d437c1735a62b09078"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7183bfe47e08c6b15a55982eaff22a76d0e9169a7d0dd5512bb95a36ce4f511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed64b0de3e90d0cecb318f4ad865f7c3a75ab0253b76089b159c2f623533e491"
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
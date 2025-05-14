class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.22.1.tar.gz"
  sha256 "9e43df28b7f447ae55534a7621e216293015cc0a626a9dcc89d3e9f4edb51beb"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d786be0518a1a3e1983d6ac8bf45efb0b56efaabdbc260bc8ff7ccd8344734c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74667f04641b12ff057f84d94b78ce1b6e3116789e71e61d6c1e6554f0da9cc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f86fe92160ecef2ce827b8b9dff26a67ff329c3decd8fe378c105116877f135"
    sha256 cellar: :any_skip_relocation, sonoma:        "c897e4f546732eac0e06bdb5ce4f2e822b4081a5714e73167c78289b735850f2"
    sha256 cellar: :any_skip_relocation, ventura:       "476f9cfddb8a3f425259ecaa1dd7e2177806aea9998befe35fc40b22a227fce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9b738cda96d7f09a465bd9c560f9c52b0faaf1574fa551359d11bae57eb6e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a14a68d59e62bd12ab7564e8224e58546c5bda3a92c5df755815f58d3d6033a"
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
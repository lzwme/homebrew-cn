class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.28.2.tar.gz"
  sha256 "c55f284210012f496b5edce926d874f3ae8a5076c4ee9318de28872a4e2abd44"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b095d0f7ac91810f4ca4094b59520a511790147f27f1139ac03364d894cbdef6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "628a78cb0a97bde53ef400f3a74e80c80b888216ba3b0521e4db1cef5c3e3375"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09c7f127eb9d0e9a2b27495346bc32cee1d6fec9b832015c7b9c9f8baa7c653a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b97ca69ae935949a3c79bca8790b52ea9eb2b5a4ab6fa717dec1c3690663f534"
    sha256 cellar: :any_skip_relocation, ventura:       "40380547e5115e420ea622d1b42822385ef777c91e16c03cd33e17a4f48d7f3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "116a8a3c53f8f02463e6f85fc7ad4733dee9be61767cae2281953223644a9f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc0f36d4cc0262f32ac35d546e2b5d65ef566c552a45a1c40db472c82ad1d0d"
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
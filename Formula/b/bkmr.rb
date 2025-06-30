class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.28.0.tar.gz"
  sha256 "6aa8ae44bf4b9e8f9231106343bf72b9ad4aa341111da4d316b2c1a329380e62"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ee35d5fcc843579bf6c9f54442a1561931b5a2e22290caf08951f84a919671b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bc1b42a609e8dd193574e6d8cbd1863486e33f8aad8c9b0c0997a7e03548ac3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c7ccdfe40fe7c49ba327c837bd38837b2f10828dfb343be923663d3bf43f866"
    sha256 cellar: :any_skip_relocation, sonoma:        "10bb7796a21e6175820f6fdbf87e60a5b6cf5e0249f19dc1c6babf39f26d4477"
    sha256 cellar: :any_skip_relocation, ventura:       "e6ef3cb3b21f7e75b528744bc5f1640b26ee04d2762ecbf283cfcae830e7448b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05f089a250bfb8fc5b94a26e855eabf3dc8cb17a3b03dcd28664ef7473a1d1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "188f120bda18807ddd49b7454b25073b87b61e292a65f5b3f25ae86ebd904243"
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
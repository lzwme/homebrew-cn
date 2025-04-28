class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.20.3.tar.gz"
  sha256 "fafec79e0cc805fd6c91b0a67670199b04c0a580195e9c7a6a4959ac99c46586"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ac5c6bd5152e3304fa25ce5f33c1d486d7c6fd1ef2160e56f3dd4ef91ee3b9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0afe0e2b190b16e3f0b07fdc474d25314b3779f54476097960c894727a6bdf98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0143d8c64e0629a8c47de6dd4320e800f6c38c07e03e884504b6ede8a7f22807"
    sha256 cellar: :any_skip_relocation, sonoma:        "12dd98e02a1f0d65bf49e5713d8f71126f49ff98b4c6f42ea1c7511b6e0372e1"
    sha256 cellar: :any_skip_relocation, ventura:       "d7274cf5f1d5206b23403b73b3dd771af6703f585c72bdc867e9d480e86411b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc9ae4f7d4f89d76a5dc0060b6f64b7df62876ef9920900d0687f3780b1f7bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "574432419d74b6581d348ca8dece38615a032f59b98ac6fae308e7e05ffb84f6"
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
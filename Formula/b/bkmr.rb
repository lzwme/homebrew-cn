class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://ghfast.top/https://github.com/sysid/bkmr/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "95da6d320acd7d66b872806ff874408d9102f96de959d43cc298c6834da6cc3a"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98afcd43422c0514d58ec02149a52398b27198b160fbd0c23a003a8f0c573e09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5701f2f4b066a9be0147f4111fcdd7134092c8f1750c4434e3e5378ea99fd094"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92a7fd435ec2f8d345777aad2ece72976192add0fcd0a344b73d5e388ea51a8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3782de066beb73150e6fa335da74766e7fa322b00686ba43f24722a9d28e2846"
    sha256 cellar: :any_skip_relocation, ventura:       "52987df4e349501827fd6f0bfbc87d064ce9c51b0f421e94e1a1a11540705c8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cf1833f5f3d1d38e108eead093954175ab934bb8040b1f3853067b9d74a5762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "055fc29033b4f57347502e8d3613a676875107e64854d1cc890a203117c9303d"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    output = shell_output("#{bin}/bkmr info")
    assert_match "Database URL: #{testpath}/.config/bkmr/bkmr.db", output
    assert_match "Database Statistics", output
  end
end
class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.19.1/pup_1.19.1_source.tar.gz"
  sha256 "d6ac2587e0bfccb0967d505122bb3c92f0b688c21fdf23d68066c9d2922fd82c"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb0babbaedb0c82e7adef5c681e0a77cc9a0d34d7572308ca826b316225ce615"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0bd58119bbc43c871431e66bbfae279f9ffbfdaff95e96a58f5dad98ca9d857"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "622a60858ab27a6e2941e3f1afca3a0c1ccebbcde55b591bcd64af1563d1c146"
    sha256 cellar: :any,                 arm64_linux:   "dc4774bc3dc726bc4d3929c3a2337049d782ce433840bf8f3221f7526772463f"
    sha256 cellar: :any,                 x86_64_linux:  "bcb7b2ef145095d231ecf0d8169d898e0d98b2a946580abbd649ab4bdf0ff120"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.13.tar.gz"
  sha256 "82dbb1a86ca9cebd9c3b08aed1036e5301054738b35c5b16cd1e4beef7a08c0e"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61e447bfda473ba850dcec92e35c75e4e3f1eaa9dbe4b6292f13edc6cb3641bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caef75c0fa1020206bd4771977e920a5933bd949102b0d00c0bbaa28881b4714"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a10cb470565da89d942ec46c8f74fa5a5984e1d93927930e41cc135ee0208377"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3fb96eafe5d6c0107111da2c0ec2fdb9b618015dadd4e3514241a2c00a1e0b2"
    sha256 cellar: :any,                 arm64_linux:   "083a3632f4cdb2ef1d81d01bcf4e50935cc7aedf4bcf95371f27bee1df00c6db"
    sha256 cellar: :any,                 x86_64_linux:  "bf997fab1a6f9ab96b1a17e42c71b435961df17457a523c8b5a05534b87ee718"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end
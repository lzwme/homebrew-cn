class Orogene < Formula
  desc "`node_modules/` package manager and utility toolkit"
  homepage "https://orogene.dev"
  url "https://ghproxy.com/https://github.com/orogene/orogene/archive/refs/tags/v0.3.31.tar.gz"
  sha256 "06105fde1116958e97db8be1ccf4734bcecd8d4282e6c6c27ae9929fa51a2ac8"
  license "Apache-2.0"
  head "https://github.com/orogene/orogene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74045032a16abdd0e5fac2dcad3273d7f78c7c571829088c9e2564f2bf51906d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d01b31a442e74156270f1cbc4f633c0d6d5b399ce865739d93f450f9c453003e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45558a5762a45c3ffd12efdf2a327076940754e847471700f9e0a96cd5cd578e"
    sha256 cellar: :any_skip_relocation, sonoma:         "095e85422bf2fc7b52248b58776b966f1b46650e8bc5c9d1fd744dc57d895e57"
    sha256 cellar: :any_skip_relocation, ventura:        "60e13e410029da1d225b77969a88c87f99ed4e96259f225855bd2a68da5f15b1"
    sha256 cellar: :any_skip_relocation, monterey:       "ad9ba1cecd7cfff9417c4ac73e440251843d101840908968bab2b93f86c8ae2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3d0a4aaadab5051d5689737f57756d60245180ede7f280b5ce2c83dca427d71"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oro --version")
    system "#{bin}/oro", "ping"
  end
end
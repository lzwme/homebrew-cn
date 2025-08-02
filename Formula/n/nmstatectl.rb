class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://ghfast.top/https://github.com/nmstate/nmstate/releases/download/v2.2.49/nmstate-2.2.49.tar.gz"
  sha256 "51000e7ccd94cca22c8a29854698fd6f62941247e7215b9c0c6e344005d83eb5"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0017ff4260d734f6112cc62a83e660ded3ace95aa7fd138757e3b742926a4f8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e00f11ba70e11491772860c8a349f35a971921bf174de88f31841cec002c1852"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0e343165cd95ff6e2ba8d2301125a467253ae4c1d1dbbdc4526a1a747230929"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a730e6be9226fd9ac5392503848c8e37a8eb48ee4395df85247a2c7d5f106c9"
    sha256 cellar: :any_skip_relocation, ventura:       "23e5711fd8c95e3403c440ce6876b547bad94e6eb68d2c72ee5243ea26d116df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fb15675139e0b527ed93ea74baef34cf04b42879133bc5c87e7a6f76e21fe5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f6dbfb18ed67a6b2b0a10cfaa9ae8e5dc368f3dc0cead57bb5086e915019975"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
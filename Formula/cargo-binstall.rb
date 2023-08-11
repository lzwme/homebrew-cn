class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghproxy.com/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "766843dd750b5f93f4726f5111fc973c5322fe4fb349bd9e4f73035b09b09f2d"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e7fe3fb7277e7c073159f719b2138ae26cb3d4600a30647658cb3ea7a94f137"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "113372677ff2fe8401709311ddbd759c43ddcd9de39d51be7723f4d82a362910"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "606b8d170a5f6389b5e3c7f06f3034a9c085ac58d573ea0e1b591eacd8dea603"
    sha256 cellar: :any_skip_relocation, ventura:        "32832f172eebf20378c61a2754b6001c211c50a5a4863e14808ffc53071b0020"
    sha256 cellar: :any_skip_relocation, monterey:       "e89524921f1ba8c39ea07ff4807800888f1056ad403538db40114fd70b7ff787"
    sha256 cellar: :any_skip_relocation, big_sur:        "09a83de6363552f6fb2804d6a1a63089d86ef138e684e2eb0530ccc9a2dea21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7456328878080200256fd7bbbc76c334f0b7ea3fd7447a33c02a2001a6180e7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
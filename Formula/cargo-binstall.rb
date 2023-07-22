class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghproxy.com/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "520b99ecb1122fcfe8bcc0a9010646cf2cbce1b4f739d881c6f314060dd6a53a"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e4bb93e272dbcdf75bf08152b127450a5ee7f2541105f5744a11222600ebb04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e97c02441b4c846e903e3899252c8d76ce78da8e98ab9ce1c1342298208f8168"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a542035f8267a901a58e3a4d19aabf96417fb11471507874e90c2ba2f9485f6"
    sha256 cellar: :any_skip_relocation, ventura:        "fe6e59f5cfed01f26309859185e4c71a73206996d7525aad53c7456773304c5d"
    sha256 cellar: :any_skip_relocation, monterey:       "22912c932ddf43227ed9c8805e3bd926a2965e906fbe0964d4c4656e59993261"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7291a495c088c587ab64eb9e001ee8a9ed436fc164084a3feaf7c7cf8db1fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9753bdd31b2a09b4fc9b72efe7f4ecf309ee20696de9481376d12265a4c1a4a0"
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
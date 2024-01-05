class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https:watchexec.github.io#cargo-watch"
  url "https:github.comwatchexeccargo-watcharchiverefstagsv8.5.1.tar.gz"
  sha256 "029c2103e83e5981e5d161f49db212686ac72c5a731f472d12be46e7ba5073fc"
  license "CC0-1.0"
  head "https:github.comwatchexeccargo-watch.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16f413123002352d2ea9ce30e8c21c74b2c58e3f44b5883f09985987ee595e1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c58395331cae06d64c50ad2515a9dec4240e6b23fe7d12a6bd2c46ce9a621c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6eef7499f9524044647275f6135694dd543b4cfbcf78438330c774765a2d677"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d1096abba1e5b7365cecd2b80e41676a5d36acb3dcd41bd2374d3fab83221d4"
    sha256 cellar: :any_skip_relocation, ventura:        "64cf9c0980484fb3092d262926fd212270fb3852142b708576b3d746583e5a83"
    sha256 cellar: :any_skip_relocation, monterey:       "de189a377a4394ec28feea9d0b9e049e74923715fe7e4b809e5492d67e6dbce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99911ce715d423cb416f2bb81d2e31f06134bfc27f0998d9ad612673b6c45d5f"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE"cargo_cachebin"

    output = shell_output("#{bin}cargo-watch -x build 2>&1", 1)
    assert_match "error: project root does not exist", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}cargo-watch --version").strip
  end
end
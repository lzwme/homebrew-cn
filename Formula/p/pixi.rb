class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.50.2.tar.gz"
  sha256 "26636239084fba212f175d843f1b3f3a1321946ea9287db0cee473ecd47cafaf"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df5328edefedfc07925c8749eb14dbada2431b8743e440f5ca029129c3297f8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afda432476e6fa31ea143f8e238a0832c16b93271faf590066fbbd76bc6e9b74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc8be91aba4beb7f7efb669e37dd541786fa07ffc407348375caa5e9c42482d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f44282978fd5ee6949fee040d47e9947fcdc20f93bc1a2251cedf4dfd4d16e5"
    sha256 cellar: :any_skip_relocation, ventura:       "ac27dde08d08a80ca9fd8e280aef84d4070685caf3ad00948b1ca6d7e5e0245c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e79903e95e4b7172e9784e0344d41e82e5770d00569f00b4e2dd1addfed89f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "980b794fd30e718f29a1cd12830c927c6d2c88412dd53cc31479bb758857b78d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz" # for liblzma
  end

  def install
    ENV["PIXI_VERSION"] = Utils.safe_popen_read("git", "describe", "--tags").chomp.delete_prefix("v") if build.head?

    ENV["PIXI_SELF_UPDATE_DISABLED_MESSAGE"] = <<~EOS
      `self-update` has been disabled for this build.
      Run `brew upgrade pixi` instead.
    EOS
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.62.2.tar.gz"
  sha256 "dba8db9c836a3bf3c6054588f4334150fe3bb7b4960c778e76f4001a18fa8e2f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f939f1bf2ae4990ae21b70b54306f2665225b24ab002394ee0652c3869d88e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f363bbb1d752c03ebaa8ea3d87eedcce5febd91b0185a0fdd4ddac9911001dd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90c59ad2f79d625f34a0aa5835dc3bdff084e481bc0af36dc4369d9e93825194"
    sha256 cellar: :any_skip_relocation, sonoma:        "fac9ebf3373dc57d2caea2fe88f4ae12e3d9904bda4aa1cde088764b1e2b15d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d400c933e342ac78c4cef47a7bb88ae9bc792e71fa5f6f135971e8ca99e38dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "303cf2aa1b705fb3a50dbda79e624a4c9afc70cdf0722c82e7070ff5220fa7a9"
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
    system "cargo", "install", *std_cargo_args(path: "crates/pixi")

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    ENV["PIXI_HOME"] = testpath

    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
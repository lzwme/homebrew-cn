class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "ebd5b62581cc4a9e16dd7bb41f3e5e83a99e53676788a388463f8ce5a3e58e81"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eda1e7bcd250e046263ef0bd2795e1a5c555011a1d04f03a3abed347e719eb78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf35a44c36d614841a83933d2e032d34a08b519120b305d83dc608de60348cc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0ae9c6db65f753173a8b5c3ed83168941d66e335e3b9abf07caecaeecf2e4e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "eba2dafe0fd846320449b159aa0c8fda95815d5b7c717b9dea1160bf685f8796"
    sha256 cellar: :any,                 arm64_linux:   "445164f139898617528080e95312c14e4f6530f581d9785ec519ad51caea8231"
    sha256 cellar: :any,                 x86_64_linux:  "b4fd35dc572580cd35db2815ea42c2b879d045bf4d69c59fb152281df28fe2ed"
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
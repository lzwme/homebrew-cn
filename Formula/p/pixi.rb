class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.62.1.tar.gz"
  sha256 "09c670ba96c0d05a67eb5823ee2398971351e75a61cc225b83e71b3066483820"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8aed7d58cd77529abb6ca19d290d7bfe039c580bf077e83d4c931829d2835f92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a0beab00a872b2e343be8e305ad538f9a44e9f9e72c7fc65a416ea01297ced4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13d44998b6548d26a0511588092b5f7b9fe1d89dbde1c2314cdeca638aada94c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c946346de252f84ebd8ade49fe739d540826dc22bda1b53fd7b759325e57127"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82a9b1717cf741b1631a7db324bcb6baa77ad2134de7cf32a4e3d1c463b0b305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c160ebcaf73bc4c2d9db3edb8e0ad8deea2e6bb924d971c2cc757ae0fbc0a985"
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
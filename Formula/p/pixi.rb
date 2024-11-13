class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.36.0.tar.gz"
  sha256 "9fcc24d6f1bf868ab4f62f50eef785df28e7d3ab1a159afcfbbb9b23fa0ddaa5"
  license "BSD-3-Clause"
  head "https:github.comprefix-devpixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06c021b980f676385e80defc0542ff3b1ab970afb93560c3e51cfd6b87c0414a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6209c00c4ee83b5a8198f51e559f83ac38b057fd1bdc046f56e66f73ad0fc1bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b1b00d83f10e3e58364ef225bce0fdc2fd1599a96c911863e7e4d04941b5f4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fca3d83d48cd25761ecbb36307e84ad4428ded459cac466bc9c7e6fb0b266f8"
    sha256 cellar: :any_skip_relocation, ventura:       "a854c31d7ab3d6f18dda4e7e0b9983c63b8f0abbf5e18d506d6950251ffa33c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5f5d204c3333ec582f469c88f7e31e95512a895200a1424bf8fe9e314bb77be"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

    generate_completions_from_executable(bin"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}pixi --version").strip

    system bin"pixi", "init"
    assert_path_exists testpath"pixi.toml"
  end
end
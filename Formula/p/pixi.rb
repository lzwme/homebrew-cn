class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.39.0.tar.gz"
  sha256 "e388330db1cb932371b84a6d3d2f09f22bd323a1a8def7d08df30217f49eb63d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd65530c7d2e6c71851a9e73e5071b03588a4b160b2d22a20670b87dfc8edad4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2ac6c3de09029bf8ae9730ebd4d45f99e8e21e83c991f1756852363bc190589"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a95c3c07579ab07442e58e573318737679d3bfecfa5dd2290096e06af25f18a"
    sha256 cellar: :any_skip_relocation, sonoma:        "88688e1042ad571128cf7e7ee609c402e798074b249e067714b9f596d78d2f30"
    sha256 cellar: :any_skip_relocation, ventura:       "6075eb18dd483a3e5f021e88fa37c72ed30208256c8effd62e236b30b9ddd857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f05867df9e3583447b1f1fc7890543d49244dc6828c222a51315ef5c0f0484e"
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

    generate_completions_from_executable(bin"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}pixi --version").strip

    system bin"pixi", "init"
    assert_path_exists testpath"pixi.toml"
  end
end
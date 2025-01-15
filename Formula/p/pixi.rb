class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.40.1.tar.gz"
  sha256 "aee2dce1e1b3ee8866decd738397d3568fa1479837e07e578f5afffe009f6c7f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38177b381c7cbbd50f4d3f6bda330abac9eea7b968f61ebbdd0318ee5311f656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30b471d26dd4b54667de42df0cac140c23014948786eb6f01c234a89a8280263"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73c490056bf14abeda05ae200e4301a1770818904f42ab19d0482d12143723e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "eea92d8e34b9aeff9e3dc876cfec1980fc54d72882e448c6d41fd8f8020617fa"
    sha256 cellar: :any_skip_relocation, ventura:       "5cc24f620aec92f31106cdd719c15577dbf7cd904481c5efe0a54fab9f0658f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f06ff3d5016a8a29991dc7b1fd9411ec1650879462e3bce297bc93a790684097"
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
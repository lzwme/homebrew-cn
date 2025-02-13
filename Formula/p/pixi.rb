class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.41.3.tar.gz"
  sha256 "9926d31fc524867f989285bb8f4d09f28750224437c0351dd237de75af2b2fb8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4e3fdcec39971bbbfb21541cc0ad80a5ec2d4a5b4d8cf0e0d2f40d2ec98758f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b94a44f8e2de0344064e6237c9d0986d520a2a587d8ee9b5d7bed6794c666b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c201d7f9f6c767b2845b19ab30ce08b418cbf5111f67dea51653050a69fd8000"
    sha256 cellar: :any_skip_relocation, sonoma:        "4caa02659e997196004e25bf0f4aeba59eaf0d4cdcbb9795b7861eba3a165a7e"
    sha256 cellar: :any_skip_relocation, ventura:       "d2a746cae531f03825d4cd5ad8cd20c2ea54d7e2de622a3eb72460cfee444b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e96b56bdfbaf4ebb82e64e2a268327276bcba7d8388911d02623c12e08a722a"
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
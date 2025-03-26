class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.43.3.tar.gz"
  sha256 "728b22806c5c3978c14362bb406c6ff4e11f1cf7bf031928a40dc883a09a8840"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c38a475f6d1f00bada944d110fd4ddfa60ffa4fdb81f61c1f903c642dcbe4667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "179812df2ccc011a97c91184ade6a94d5c611b652d32cef577bebb66ce15862c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84231c2484b51584b33a11edaddac8f70c362f56e0f2f1acf71377336b31d0b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb748236d031067bc1769d9fe4b9dedc296ba685e16f0592d4b2a429ab9c1513"
    sha256 cellar: :any_skip_relocation, ventura:       "fd25268176ba1cd48efa14b34033284d5ac16c7a7e9d060c91c22a2929fa65a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c09c9e232f2eb9aec60acdfacf56982a8cba3d789d446c2130c2b5f91cadaa7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea4aa67c91636fc9448ca95cf9b9ae90a7ec80e1470e5af639b6908acdf7b8aa"
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
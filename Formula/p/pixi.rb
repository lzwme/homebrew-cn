class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "795d6f48279d800507dd8a54f7c6c214c72e8ec3fbfd7bd41a0c935c775a7fed"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fffe79968dc12fac68fcd294f1dcda5423dcca8691fbb8ed2588c5187633aec7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42fa732c2597ee7d8d9995423aea69b7d0588c51cea15c0ccb43727b7c566021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17acdd4ebd985f6beae280649d210bad16eacdb783ff46cbf903aff9b7dc9149"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6960db9885361e5283e57f6935454beb743f1f5139edd9dd9c7d586796a67fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c5761901fabfad43b9b3fb5fb868fcee6c2687e13570b554119dce6d635a664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6138b0c5a0d21da5d0117a8e85b9c73a41690272eabdc3c9cbbe05833b2a8ef"
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
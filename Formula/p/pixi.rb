class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "ad11fabb31f5c7ec6f3e98524decd2fed70afc0674a6048fd7727eb12d6fadde"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0388782f0d4b5458d18ae5fc847b647f034f8e86ff08f909b66fcd96450cb21c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da3a5a0fa1853591cf5b9b782400e6c2f24529beb0269bfcdf1f0eca96ef777d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3984ba0f1d9bc1cd9be5b1a9be8965e55f0098097f68d39870fdcd56a22e9df"
    sha256 cellar: :any_skip_relocation, sonoma:        "15f168b0be029fb276a6720cead19bd806d906fcba10ec630b2423c2badd43f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f04ec05627b13c3659d95cb7249531a683ebec3be8f74001e01a6f1fd8f5f23c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f650df14ae5dd7b48a9611ea3919a58e38a0f932b0fe46d5f3ab7631a02caa1f"
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
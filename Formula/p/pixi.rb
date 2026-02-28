class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "03527008a7ba0e76698b8f8870fdb3519e599c424fa718e55f1222382a5f2c6d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d13fab0d72698fdd1ff0e003ebe69e7664c50263180a15fb8fe1a3bbf6a88fb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69c989f69fd30ad4682530d95dddf7430d81c4a8db6f979f22eb6abf47418e56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "797517f07d2ce719f037126b804c7c78bb820582baee4112efd39af2f9563a59"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb6b6e7893d83f57b08a1970600e7d0bc5c703875eadc46e362c06dc02f1acdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54ea64aee6e81ad0054f0e723ad5ce036cc6a67713bf91842c7e6a04f01a5810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2dd82119ce5658918827289862d4270e2a220bb790228eb5434ca1c478461c1"
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
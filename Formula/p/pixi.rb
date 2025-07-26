class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.50.1.tar.gz"
  sha256 "b247b6ec361232adb4e1d59fb2aa7b13783c4032666f82ca960e9a482b9d87db"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47573f5909505bb4b3a12ed555cd310814b235317fe3da1fd9d0df75a8032128"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a77144a4352594e27cb573d36ab6a07f1d4fc6afcdfbfbae370d12dd7cb912c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dc9c64aa55cbb00f501e9e344d343f4660903a1758787a34088a08abb3ed713"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f9f1357c0493d86953fadf343425c4857a809ffcc29e886ed6bc4b2edcad8fc"
    sha256 cellar: :any_skip_relocation, ventura:       "cbd880545cfdb01135639a16f3f27aaa50a594947a56f8e589b0cfca1d6c0bcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44f26d27f95e629c2e106a4a5c02369fbfecffc3b1113c181f49f8bd05752b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d350db8d58364eeb892a38922afd8da9c2cff0f498cfae58e4717ad13d0560"
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

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
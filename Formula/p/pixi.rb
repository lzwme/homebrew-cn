class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "74a4e5964139b662339ff760fd4b4b6378b294dfb221e0680cb09e239e95a047"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce3d63b9bea5dbfd9e066b560850bf5ab92455c28b8cce82253844fbb25c0ff9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f063e5b6e396bcec669d34704bb326151469f777ee944d9f2771ef31fb8f9cae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cba3b756977a655adb53b2699681246ec22c3a6675c03035a71b4865dfcb804c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cf940f06e019d4603adcd6ab559351e2d985ee87108d816ca55eb6f82652c81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50f08735436b60db0e94fab336fce45963857cdfdf8e17489e6e4f3f6b64662d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a75c78823eeb808e6856f0d8d1f73b80d750b4426060b0eb41b69e98e077bfa"
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
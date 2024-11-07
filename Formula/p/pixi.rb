class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.35.0.tar.gz"
  sha256 "2639c190e88e8ec14a8d51ef666074be246cf89da748e14ce1c6af3d8ddb2f0e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a94b8f4d40098e8cdacf341fd0b02b2f19b0afda7d9a30dbfd9705efce9283f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a21b6626d84bc27bc7d66247d7a8e15a519580e12b25838452d6ff2f5789530"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a44fc9cd399c439fae8f27522da1af08e11bafc03954c1b422caca44aeeaf020"
    sha256 cellar: :any_skip_relocation, sonoma:        "86487ad823b21738227f8afd959047213ef0ce3acf29421960e6764c0c0d90d2"
    sha256 cellar: :any_skip_relocation, ventura:       "4306c117be8084b6deac15b13c84e1a4571381b4d15170be6a7642a3103e4aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00a202eaaade3140c8f725c8e7419c0afa0f1eb2402e6164e739b27fe7ec23a1"
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
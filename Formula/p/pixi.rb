class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "d545b0faed545ef024a62dbc15b0cf9a883256c385d06579587aed10e994fd25"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c2626070e71010f641efcc3ef9fe440ff70f0c7088e750a96745c307f13148f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1374ee7c08f0629cf9dc3fbc2fa9c2f0ce6fbee7d9fb9f0761b6980026eb5c2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a8c49614f3dd782a4965eaffa93ec30d6c60a4c1b5530d2fe15484365af4264"
    sha256 cellar: :any_skip_relocation, sonoma:        "5879364f427ae1e04318c0c2e0a4cfedbcef300ec5c2729e3fa9e8a41b642d14"
    sha256 cellar: :any_skip_relocation, ventura:       "67f8cd5e6874d6536cbd0a6b94e600e1b0eae0d3cb9b913a3f70ce5890ab8ea8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43ea0af60b162991d8edfdaa4df43b9c9e47fa42d2c98872dd5bf1547cf8f9e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83843facc1d6424a8c9fb7f5121c0b6dbb290e02376ce2659054eb65fd57236c"
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
    ENV["PIXI_HOME"] = testpath

    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
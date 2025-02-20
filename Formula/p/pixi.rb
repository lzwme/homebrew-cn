class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.41.4.tar.gz"
  sha256 "569e015e2281713dd65175febd077f4544ad6c42d9bf50e2e9febcaa792a0718"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7687f867ee3e68b32e4ff367a9c43645b8942f0603a714129d540885740f1fda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f4c110bdf042026cae43f2d63c019127ac24d40dcab545ffaee73d990fd26cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dcc8d9944a8301e790126cf7e26a17438beb8d1a591f2662ac162065132d127"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eeb0e3f4ec05687f850596597104743aeae22a5bae05cf85b442dde13b45c95"
    sha256 cellar: :any_skip_relocation, ventura:       "436b2aa61bfa1bdd1035e3e8b52ef1e49a78cee89abfe9e391ef9a44abe20ef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2925aaf860852fcbb5cb22db28c48ea6a1aff067c614ea317ac05fce56426cf"
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
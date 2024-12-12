class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.39.2.tar.gz"
  sha256 "19739239e51eabc93da47c58d22054d5be18a39a7e63e2a618e084c71434232e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbe0c9555f713267f1ea936b45022886354e1d8b94ada158d711dfc5f353da3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c4befa10eb9d636e5c604ec894bffaecb662f92c07b84f870fa548a3a09981f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad7225feddf5423ed7348468d2fd77853ad4c4a1a11e6b7db6d135b925ef035c"
    sha256 cellar: :any_skip_relocation, sonoma:        "930a4e3250a7576e28ec166f3307c34cb1997767f76687aacd1b617af2f1b8d3"
    sha256 cellar: :any_skip_relocation, ventura:       "5974f015624e783ae195ba2e6aa2abf95a8dc051b645386b8573e7a34f30ecca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ef0da59e1c0148d5fd0ac68c624a2d593e099efba861cad3c07cb9aa5609503"
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
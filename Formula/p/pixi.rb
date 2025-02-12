class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.41.2.tar.gz"
  sha256 "0c8a35ef80cc43af543fd3ee439471d200da93a36d47fdeb5704e913e249fc1f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dabfa1cde81bba4fcdba09802bc1c7d408eda3fe37c033bb6ef0677d51d28ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdcf560c7732616d3aea25af397f3fea59d65a09b06efade0257d019d02de297"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c00aba6729ef963ef0cffa70baa8e9e565cf7a094780da0ed44dcca31c54b33"
    sha256 cellar: :any_skip_relocation, sonoma:        "e22ff9edfe7c4412f05f6dc6f40cf83a414f93e0f861f3416d4efff482d6b618"
    sha256 cellar: :any_skip_relocation, ventura:       "590c8ebc6fc5d0e99e6c2078ccb8c722754eb5dcbb43e9f671fd184ae588cdcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f893219a8e33ef45a40344d2f4fc0b9c800b606c076d11548afb18ee8faefe28"
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
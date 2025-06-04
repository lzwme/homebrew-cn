class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.48.0.tar.gz"
  sha256 "008d49f5adfece6a0cb8b4cdf2a44b0577c9d3760fdd64b466ae54923077562e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6caa997959cbedcbf79eb923f670871234c6e4ed21715529e059eb46a1d45689"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "765cfa417446813ad3626dbbdfe195b69cb89c40a1b3791bd2c291acca2131ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b07110caa030ac0d48173270b80fd4b69d91aa1cbc8387e360293aae768008f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4495dcb5270b7634c6dc146a9797893fc9aa85d799849ecd08afc4b4f931c7d4"
    sha256 cellar: :any_skip_relocation, ventura:       "514d4737aeab72617534c78b1d6620ccf15df23ff12c1246726112dd55562fd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68884111625b02633ef9db4b2d0a5b3d634dc9914c98a6488619ba3f8aa3fe2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc41559049e647fae2a57d06a5fd43f55aae3e09faa4d17f012c5b372698516"
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
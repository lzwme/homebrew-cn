class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.44.0.tar.gz"
  sha256 "9c646c472659f01af7a970e70e4cb63ee5c4f2c57998bd29b697a97e128155bb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c103fe46b4a7972186017582f823986b7e80d1b2b4670074673fa1dd87f0567a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f643ae19a6a4d6fdcf5839b73425beaea3f960d0b889453433c28438e82649e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d75cd6b9e4a07232f9da31d088e6626ef7638b468ad096eb24e750e242f6503"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1f78d2d7e958c6c297542bc47c36e84241a8d60502b399bdcfa8cfddba8e03c"
    sha256 cellar: :any_skip_relocation, ventura:       "401fe94602152708581b40f958cd08dda7cccd31b4981f3456ecc038ce5f9911"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "953579930928e0584c5c13b782dcb00210b3192fc89886c1f9a06e29206af5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9c98b7bea1905e133bb0cb3bef8b280b6eb04976ea2dd61bf7b21b5cb8a917b"
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
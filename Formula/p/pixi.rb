class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.39.4.tar.gz"
  sha256 "df4e8659a31fda97e741cc391549d4e814562d06cb82ccc95fe22354cfdf8817"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "987bf205027ea8d8da035faab41c8065fa73865109ea4a415cc75831845871b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a27be396d6ec3dffa2a106e60aa19a45e512b785912aeca3413d5788b1895212"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1908f027f3765a9576f6ccf956a11f22e11ec2695eb6f8ceecb779b469f61a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b128cb14bf3df0c116ac836fe701957c4bb82d2bfd4bdb3e24f31caade3dd54"
    sha256 cellar: :any_skip_relocation, ventura:       "08da6ca52ca6a7a313b40baff13d5fa36e07059f5e865e63d19a1668652d18e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e58fb5c03dc3d46f8655024295669017ec4bd32e0aeb9c736929081acdc5b8de"
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
class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.43.0.tar.gz"
  sha256 "44f781049bd5d01f550fb17cc3880a36df29bad0429453c6527ee316fc0bad20"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3756228d9de80c1fd5db94558e15bd1f2f14fe924a641b20a4152c2a9579a70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c19b18d5c760868c2dfdf4b51f4ee710ff6b64802c132171da2c8544b214618b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff1b06ee469fb9d6e12b3adf57152574059da8c0e331c4d70a1836a1d3936c01"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b3eeedff7b4db0e6bc6da42136843fcb36afcbba2523946d4bc77cca6ab3ab1"
    sha256 cellar: :any_skip_relocation, ventura:       "e407621c538c1e8e2baa84995c9e46e39f0a4496f2449a26b92a8facb788d4dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9713eef96f56b756e15cdb53ebd12e50f9a41ae6a2fd5d207e8d2f05e1c2366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7582a173795801c52a792a91b0682a403818ea8b9be9b6cc74d30cc812992bdb"
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
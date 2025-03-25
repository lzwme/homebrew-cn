class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.43.1.tar.gz"
  sha256 "5c0a853c3492d447b7be125fa2aeda8123e5ac807ecd020230260410aa8f49d8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d30eeb7042daa49eb212c478a1b578e7910b425dce0b1a2164c2b4c5949b70a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e398110de666d9038e5e7f87f0a351fefd6d23098d70f481bb45f9566aba4a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4203f6fcc47602ac81d1b786315165a398b7ebce34d0f0a1ca6762a0ae6a8dae"
    sha256 cellar: :any_skip_relocation, sonoma:        "523357e9ebfa956aa298b2cb684b26c0dc27bf2b703862fd56ffefc1cd777d82"
    sha256 cellar: :any_skip_relocation, ventura:       "bf63c5b0aa7a18aef5547fdda6efaac2a554f18a453113fd9969b4dba08ea8da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3ce6747c3c9b9808e777713e100833b4c55847bb620247534838b6595b01dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45ec0af32bf0aacee9aa533cd692ee99155fe9d52524878ba0774e4cd8c7f698"
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
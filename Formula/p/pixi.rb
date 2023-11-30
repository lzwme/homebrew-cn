class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghproxy.com/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "af2092bbe1bfd480f5e187c361da234965276d2eef4e00dc393b30c2ad05f168"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16e6808e150d32d13a28e5123baf32a20624b8b4b69f6348e0c968ea39eec706"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1913c8cd88f150cff072824163be5b63dfd0eea82dc753f8fc5fcda02edfcfb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d311cc451aa8774feb742cd14f4ac969003631676e5638385968a796d8444aaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "95fc4825b83bc574e320d614684e3798a23736853fd0a697fd0b89ca25c1c1f7"
    sha256 cellar: :any_skip_relocation, ventura:        "1b05a1579a2f4ae8663c6960c16e739fa5254fcd05ee3205ff45a0775db1fe48"
    sha256 cellar: :any_skip_relocation, monterey:       "3fed42867d15f3095263f0693a997fce9759aac549b5057d7cde897ca61b3b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67bb1bd6bbb5839aceefa08bf9ba02aaa543b5c0b2c4ee123e415013706d162f"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip
    system "#{bin}/pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
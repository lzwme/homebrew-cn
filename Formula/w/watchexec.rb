class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://ghfast.top/https://github.com/watchexec/watchexec/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "86da4682d38bd8357fee4652f02896db409dd40d35cef5582451f6c1adc2271f"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a955833c06ce5b3ede8012e15a66166ac776efaa981d1039813f684cd769f15a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9c3098fee512b262797d108b5e4a712328b2fe0c886c8a11b1edc908194bac0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42084540680af723e7ef869d632d4f85ea79156cab7bbfb0c207444f3465f389"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdd43b8dced8349e04150ef405be2b34474f9d541c591955a1b39ab6a7560892"
    sha256 cellar: :any,                 arm64_linux:   "cf7685010b6ef7c30fb7d5ab246729736058fd34d09e00d9aafc1fb3d3ad6a35"
    sha256 cellar: :any,                 x86_64_linux:  "e2c5d90cf62ee1d7532d00e14156876b1b5f00873cee051f61446c0f3688980e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"watchexec", "--completions")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}/watchexec --version")
  end
end
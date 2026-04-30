class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "c4a3ab52faff4405a099e39593226d857dcb796db65f983a97d65ec8bd535cfa"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95eba5eb07d7ad8ce5ce1042889df0aef58cfa7177faed8ce0772415b7fa24b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "143694bcf92e2f3086b894ef9e3a4b2dcd0d81dc022cd954bd8b47c8e63954b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "453fa412543c7fc288f7254403f238fd2bc5f0c3305ee76d680312736eaf5bb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d3db399842cdc50316cac4bdc3d81fb3a08ebc4bf37a0966cb510622c3a9f40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "547407f1729ffca9ff4c03bcea35e7e59d0b3a15bec6024f9a344d39d1d3b5e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab25dbf4bfeeab21048fbce25e5782a33d69fdb1146e4e7edcbbd54b4302d1df"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end
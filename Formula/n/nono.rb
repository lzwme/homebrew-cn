class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "ef9b12a556ea2a75d7e7eee3266a2a9a5acd228ba1f151278372570fb58391a2"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c20164ac527b80a5c57d966447f0a8ccefc9187bee2182f42347c0c3c81e332"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72c5dd672b70959f540068311e844490fe8eea9338d07eeb9b61a094345a244c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a10b71b792f502194a925e53ae51964a18d6b0f7a4aef30d2041cf145cd46e36"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4d6a215edd6de32579f1865c8883a52ddca8931298c9ff3cce723fdbbad061e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "481e96ac21d8a8935834c998e0a16bd4f998d9810dfe38ce8ea499aab9a11abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca92f180c20723619dcac66d8a1cc9bbb09708fdd27f7bae524133e99505fb91"
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
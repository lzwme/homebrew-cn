class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "c1a2118c211d39eb0eef53d5c8ae671fe219a81ecec67089baef5d2ceb1203ab"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c644b1def8312aadfcc128ae7c3c05eb60f887a836bd46361e92be28020c911e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e736bba7ea781c83b05a4829010719fcf04120d67b0fe5050372542089d2f274"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ddf94378a6bb01393f1be07aa2695dcee35883c9c59e51356a14595be731016"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6a66d4220b88ccc052ade7e732b24f5f491b748368f3912eea88b3ebef5bfbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "049aecc028f274e0e50606fefe57f2e5749263d35bcbda2600f5fc1969b68256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b955a118b14df89687eaa627d68a27c66c860d990a0d6ea4f6188428bf7501c5"
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
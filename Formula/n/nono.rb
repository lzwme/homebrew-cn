class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "ca093ae1452ab80e28cd1f66846d398bbd1ce25da1ad772c4c926ce52bc6abb6"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7233197faf278c719ab25cc61d9ddb0e75143f68d938a40bcafc0c4e07638600"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed8a83bb9ad79c117cc062037b8d166f64dfc1b9e9cc801d8d78054390838c41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18a8ef7a218085496ebcbd812ef168b38263444cc2b31a1b19af59f9029b3803"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b359daa6e736c0896f1c23669f4340b08f05babd4ae9feb6950baf0cb4c9996"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "decdc95e47e9609a3d7bba4cd6a88e3f9a4f1432e5a23282b2810dc01d17f02f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07f433ef1e190ff21e46574a6dec5f0d151f3b5edcb92efff20882331ab98a29"
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
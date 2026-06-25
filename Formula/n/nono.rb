class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.65.1.tar.gz"
  sha256 "a342deed7c16742c955b3a2bdef7ba558476bedcd298ee12c95b5dd47a381a9f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b301668175b5ee7b22a75ec1ae66c3f3d29220098962dbfa2018d466d119c949"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64cb2d4cb9c8e9e217a201f6233b95a5b7c49f0e3bf8d0c828eae7fefeeb1252"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9627e218c78fd522618061663cbce2e5c2de85dbdf57abeb81d83bd97b6870c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7650c210b6c54fe7a70a852580c40d4a37d5b8ac0e8b451c06ae6036501175c"
    sha256 cellar: :any,                 arm64_linux:   "a7a5dd83188b532f10c3fdc6191c7a1d51c76cbe4654decab723218fde6867e8"
    sha256 cellar: :any,                 x86_64_linux:  "1c08329fccb17ed7de354f34f2d8c0918d52152ae85defba6b6b96f387bbbe3a"
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
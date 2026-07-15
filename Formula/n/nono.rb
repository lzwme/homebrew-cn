class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://ghfast.top/https://github.com/nolabs-ai/nono/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "bbf0110874f5287142e0fb28108d2b3628c84ac8b0bfc0ba2f02e416a80d261c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f31d16cf6ae657050e699f0ca1001346c87a32a6382b299838ec6f0dfb90e4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3c9b9a4c495cfb37252d5a31b4c93d3d29e2a8bb90db4728577b78d08c6312e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65d96ece9a6612d34caead298ba0b62a3aca40ef3562a13c76b0e0d9d828b000"
    sha256 cellar: :any_skip_relocation, sonoma:        "45c6b0f038730aade023bee4a775f27546c4da5c6d80f6ffd8a2466de358b09c"
    sha256 cellar: :any,                 arm64_linux:   "fc323ea983c0daf41a033e981fea66e2a8e6a8b3682c5ff09f265fd193385888"
    sha256 cellar: :any,                 x86_64_linux:  "c45d333a24e4a0a147c2f272598c363046182ac2a7c60066e77ca1bd4c060841"
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
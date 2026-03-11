class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "9f3673b540c3290b336366439b70c776d1b04635342a6c9ccfcd2f0a1bb0d42e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26c2885db6892628c7e05f678e8d2c8a4289fc493100b2c4c801bb71f14732cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd57d79e86d8f19589358da1e58caa79453a6da1770268ad56f29ca70f7f5d2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fcdab37c330e394eb7d668715015dd9afa7a40cc83d342e3947f24320fb68c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a75c1244a1e0445ec01306ec35362b3ea834e77a3305f85a88e01493b27bb45f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a7b46f20dae82d89084a215e207c78a96a8b93d733836584204af8bae498eb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1796ef4793d2a7c08652e5eecf08f1798b3821f9f5b9eac89c3b6d05aa15d8c"
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
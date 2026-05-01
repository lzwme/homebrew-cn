class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "953b94351480be4fda7ecc558eec073d4699151bbfeae0ba65a79c4f3b9dacf7"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03792b2d25d928fcbd58339f4a1e7350748c8aa281e548dcc4f2eac9cb4f167f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57ae514f655c4a7002e6a42aec73edbc1012db501f14f33b691f697889ed93bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d91861d488aec5981a9211cc14f3fc2e294a143e2694ed905bead2683efe5e20"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ba8264b0713f05773b84fb9e29f4ff678590c2701e6e6804562f117427ba849"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9794d2a99c6227e4e99267b301a8c127fa854eea10ad8608679548bfa15ffc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d56503cde353e3e681c2b5f5b534c10dd5631c2e656ab2900b771e9a3f8c9eaf"
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
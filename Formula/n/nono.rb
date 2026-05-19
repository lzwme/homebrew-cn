class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "30a48f7610c37db5c24f6d5b044f3db0784f3b7aa0c10b94937a994fe3ba9b14"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86cb3a25a62e6d70c6c2c2f9152c0c1fd8ee57e75b29058311298199649b8ce3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3e25508d0d384bea1f471738ca7fd98e57f42fe5727f5f1caeeeef98174ba9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45d7f331586c84446fc039f3134648d78f4c0703528fd49c30ada91ca72f3198"
    sha256 cellar: :any_skip_relocation, sonoma:        "8507d8a74d8fd6b2b0165d664c5931de15360ed1ae2ce36a0af32c9ba5e100a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1025778f37cb64e5fc20680ea471dbe631515a7d1138bbf98a9b9f7c383bbd1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d46ef46308c2e400d461234cc93c9f929f8458da35d718404fcdced4c274907"
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
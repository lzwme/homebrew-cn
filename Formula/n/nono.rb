class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "678bcdf32cc3a866c16346131112cb90bef48773a40290619cb6a615f80d81ea"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c78c3fbb33ed6ea099b0dd9670f8a49ad6056e645aed39b9011bdfb5669bc66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fddb6bd98030c6c8be5316943af17eb5f9c7ca51f179e81d9ec3a10bf7b3201"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aa175b791dbdbf6eb564159736120cc7ec978f349f823873307a322b70bf6c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "68f25d0280b3b70c94797817b8a3daad70019117cb6dd652397c8766070c4fab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffdfc5c05411540349137fd1da2aa7510b660c598ca5f09149bb76a6d7be0d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c490baf6ec230d38f9cf90992e07b832691d4ce2fe2f73e3f88f6dc4be6b9e8d"
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
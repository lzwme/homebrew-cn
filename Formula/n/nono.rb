class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.50.1.tar.gz"
  sha256 "c219e8a19713ff59ba39e24a5c611035b9297b60e59ab2b46756d8d1799b382b"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a21b1408461090be3858b9552b539fbc81aa04a39db62649d3c74d83bed53ac5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5fb82b2f40d086b83a9b56017fa9716261eb5993a9e3bebf9332d87bc869dff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f9f8863fa1b059a5bb77ec9aacc903eaad3d5466eb8adf93b0ff628fba22a80"
    sha256 cellar: :any_skip_relocation, sonoma:        "841fa633ce1dfd767512734e80f0c8e3ca9c0961c336529ce1559d1d291f320d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e13ac235121e4ddfbf32207f458c45cda1201b0c6eef07c61b9dfbef52e5d85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86a31a2fd884c722a493da21e4dcb6c7778309171369ed1577c0c49a6ad4af8e"
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
class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "d58391e55ee893cda5b468c5e9a0c5cca0e425e816d7a3c358e696c1a3272114"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e807be6bb9e16ee320c91b788723e4b05abfdddc19cda9f30324c5d21fb80376"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3671cc63a65ac151177cc9244c8bb5c46c0a826cb512f2d2f184002745be73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "750d1411ca84267e0aa169dfc323672ab458fb5a1e2f006715edc27214fb76e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "587ad62102deb0dcc2179f24da5e5a27978a5d0bc638e808a01f8708fd414584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "707933cc4ec5bd51c7c521999b4b17277803c2b4d7d3e6be0749bb458a5e9f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2197ba88f505b4d83cff3af06a6476833f4d9ad9b8855cceb48fbd9b8d89ed7c"
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
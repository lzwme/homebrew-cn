class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https:github.comabhinavgit-spice"
  url "https:github.comabhinavgit-spicearchiverefstagsv0.9.0.tar.gz"
  sha256 "c798cc30845b43e9df1a530af6ba132e4a95770cd861f5b030925e11a2c8a3fd"
  license "GPL-3.0-or-later"
  head "https:github.comabhinavgit-spice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a52f0b4649f858c8ea073b70fc5d7c56be025232b0d7e12cd2b65496367c831b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a52f0b4649f858c8ea073b70fc5d7c56be025232b0d7e12cd2b65496367c831b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a52f0b4649f858c8ea073b70fc5d7c56be025232b0d7e12cd2b65496367c831b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a352af4894f7bf28dff834dd9c6cfcf6eee07e344accf03e0406ce749f6de71"
    sha256 cellar: :any_skip_relocation, ventura:       "0a352af4894f7bf28dff834dd9c6cfcf6eee07e344accf03e0406ce749f6de71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8ca7adea8fa623ab630a2c832b5c4f4d9ece69535a6cfe5a28e51aa8f6a15c5"
  end

  depends_on "go" => :build

  conflicts_with "ghostscript", because: "both install `gs` binary"

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"gs")

    generate_completions_from_executable(bin"gs", "shell", "completion", base_name: "gs")
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}gs log long 2>&1")

    output = shell_output("#{bin}gs branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}gs --version")
  end
end
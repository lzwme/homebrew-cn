class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://ghfast.top/https://github.com/Macmod/godap/archive/refs/tags/v2.10.10.tar.gz"
  sha256 "5dc8b3085a290d39da4aaaaf444207bbdd46a7beeb04593630e8e5186b62ab57"
  license "MIT"
  head "https://github.com/Macmod/godap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a02c1b8bdc22d87f86cc6656bb78c1d10004f5978255d2ec973d0b95c82312e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a02c1b8bdc22d87f86cc6656bb78c1d10004f5978255d2ec973d0b95c82312e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a02c1b8bdc22d87f86cc6656bb78c1d10004f5978255d2ec973d0b95c82312e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a52fa665e4077fec28fd805f13fb73bf88c79538955714cf85d20375f17be2e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "014045243d7f1a831d17921f3113c77664ddcb1079b71146117c1a5eefa583e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d926aee8c6f7f99d082054dd096235597e5acd748228104ad5240cab1d18a2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"godap",  shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "LDAP Result Code 200 \"Network Error\": dial tcp 203.0.113.1:389: i/o timeout", output

    assert_match version.to_s, shell_output("#{bin}/godap version")
  end
end
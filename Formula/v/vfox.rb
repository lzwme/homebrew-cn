class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https:vfox.dev"
  url "https:github.comversion-foxvfoxarchiverefstagsv0.6.9.tar.gz"
  sha256 "cce54bdca499f761d6dab695141f748ba8b87f147c79a21e1a9f4357fa6b15d4"
  license "Apache-2.0"
  head "https:github.comversion-foxvfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aef7b41c539c08992e3bda145618078dec175a454fe8c0db4bb0b9d6c25d07f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e807fe914b6305bbbafa39ebfcf65cce1d2ccd23a0d2106a198f3aac6f0c795e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f4d170b3de46f55115ba2f6bccf0d7e90a92bad59c549c66c9ef97cef666fba"
    sha256 cellar: :any_skip_relocation, sonoma:        "a938835c44c38b9accb4a63e9659e0eae1270fe8697635a9062cf4358f136454"
    sha256 cellar: :any_skip_relocation, ventura:       "37bf081d394e59eef6eae2a022d74010c7f0ff784667f87772e6a43d4cb8789e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2542bf189afdd0f720b506e5b2a6fa1ca3c5cd09a33ea5b19447831203e00b8e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completionsbash_autocomplete" => "vfox"
    zsh_completion.install "completionszsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vfox --version")

    system bin"vfox", "add", "golang"
    output = shell_output(bin"vfox info golang")
    assert_match "Golang plugin, https:go.devdl", output
  end
end
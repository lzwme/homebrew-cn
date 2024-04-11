class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https:vfox.lhan.me"
  url "https:github.comversion-foxvfoxarchiverefstagsv0.3.2.tar.gz"
  sha256 "509f07f2c2ee3bdc18f9745bc05856b06f4f7b5a0200c3c0758f2a86a6ab1745"
  license "Apache-2.0"
  head "https:github.comversion-foxvfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c116aa014c96b1a4e448a97570b9a17d7ef951d7406246b757c67844bd35595e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eed90b382975f02a8f0b2847f1b6a16b4017116c779e7d57c5b5e2ad01c862ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0822989fa5e2df3eb3fd12f022f595a664ecf1a3d86b703e3ef0e342d541408"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8e46985c900b1bc59c38c23726e00ba1d8b9ef992e6ee54cd3a3029121685d3"
    sha256 cellar: :any_skip_relocation, ventura:        "caf77ef0dcc435452a5800ca392a9b923192239cc62e4540be595a8fe3ab138a"
    sha256 cellar: :any_skip_relocation, monterey:       "f76d55747a75a252a5a2cbf94813a52b985ca5d166561932da46ff2f153b08fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eae67afd9ac2166d7d3996aae0819d20bf9dd06f6445fcab6fcebf8d74e154bf"
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
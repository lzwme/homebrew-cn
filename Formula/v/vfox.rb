class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://ghfast.top/https://github.com/version-fox/vfox/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "cbb1d2c3438458df6d4ec0ad31f0615c89258c942d4ca2c949ce5dbd3361aa0d"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15844cf9e9396c86f12d69fd51d7e036fa786866b5736357e1586da7eed6ecb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7504cd7823a2a19f27ecc9653e4216f442f5214b29df19642d0038031050b11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2e037950e7f2c7c2f343c248114a8760ec17a02e6e04b8e56a63aadeac3c346"
    sha256 cellar: :any_skip_relocation, sonoma:        "1541e907da25662be46cf0c87e9988f2af3f32cca490c09072848ac86ca902a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c44cf884dc718358171cab84228698de957492b173698a2142b9ef76b5e45c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c029ed55ddd3dbd807958f381e551d8ba8de96b5c8e1b601fbe14efdfcea68e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output("#{bin}/vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end
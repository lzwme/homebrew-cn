class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://ghfast.top/https://github.com/version-fox/vfox/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "eb4c96c1f5ffe0d6f578d66b48110390e943ef1353f62470c66994d521e2f748"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fb526dba9e9b28ce68d9c836c9bc7fe1b682b74c510beb8df51b85ab873d6e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc8fef00caabe6ca147544847d4ac5bfb511f1973ee8a9ddaf7b30ada2c1b697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b4b6dbfc4c4ee03791df93e0dc221df89de8572f8e39ebc80f2cc935329e418"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d3fac3a4adfded00735ba1b7d1a1a8a8aedd365a7b8e9709e2977d68bab8324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a791610138278cfd2c5f3ff898f7bd6435b7781f44bdd605ed39ce30ac9ca356"
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
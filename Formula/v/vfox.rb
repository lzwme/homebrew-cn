class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://ghfast.top/https://github.com/version-fox/vfox/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "4d8a29a8207f4200d4010321b91b924c8599d1ba70f0200f60c27dac5ecadbfb"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82d0aa93299df4cd5c3a60ea5d88ccda436e4dde8969cb47b0103aa2df070384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "230a97e71a2032e4bc43ff3a42a80edd01bea6a51fc2fa99029b1de6742a43c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1500044b287f2272d932ad73dafd0e598758a80126ed4a10a5e323862d8c2a29"
    sha256 cellar: :any_skip_relocation, sonoma:        "f104d009ea82abd423240c6f163df43f3bfc49fc5e93a6f49ce07ab38587f9b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d94ae5c7f3d86a9f37bea2b335d6e532b231520e5ad88c7d12611e28722c6395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eda436b1439eca19f8a3d66742c884af024cdacc5aa8abeb240ed2aa9ecb3143"
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
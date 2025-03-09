class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  # homepage site issue report, https:github.comversion-foxvfoxissues426
  homepage "https:github.comversion-foxvfox"
  url "https:github.comversion-foxvfoxarchiverefstagsv0.6.3.tar.gz"
  sha256 "3d9daed3cd3938e7c0e4881b09b15717d368a9993ff884067d406d50f96c4733"
  license "Apache-2.0"
  head "https:github.comversion-foxvfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55115b7e97a0b2f784ea8dfda83b67cc1764731e94a76edd2d85f99b8b51c896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55115b7e97a0b2f784ea8dfda83b67cc1764731e94a76edd2d85f99b8b51c896"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55115b7e97a0b2f784ea8dfda83b67cc1764731e94a76edd2d85f99b8b51c896"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7532cd11c7cd63e0af4b45975de08332b9e2d50a9e89edf17c61a293f3f3c11"
    sha256 cellar: :any_skip_relocation, ventura:       "c7532cd11c7cd63e0af4b45975de08332b9e2d50a9e89edf17c61a293f3f3c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "862ff65d13513ce2494820951e84d5f4698ae13cd54099eda3a3c54327828ed8"
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
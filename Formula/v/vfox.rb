class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https:vfox.lhan.me"
  url "https:github.comversion-foxvfoxarchiverefstagsv0.5.5.tar.gz"
  sha256 "b97d4f1dde1be06bd8935c86ae7f87f9d209c41338febfe384077da1a78711df"
  license "Apache-2.0"
  head "https:github.comversion-foxvfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46419dd11546611d8646f10977d1a1513e7297db0d9adc3c078e86547dcb0d96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46419dd11546611d8646f10977d1a1513e7297db0d9adc3c078e86547dcb0d96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46419dd11546611d8646f10977d1a1513e7297db0d9adc3c078e86547dcb0d96"
    sha256 cellar: :any_skip_relocation, sonoma:        "089dc3c2d791053dfbe33aab8481888ea29191782c1bdfb87bba75c62a1c0d48"
    sha256 cellar: :any_skip_relocation, ventura:       "089dc3c2d791053dfbe33aab8481888ea29191782c1bdfb87bba75c62a1c0d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51e37d27d16352e6eb428628bda761f99aef5de40a2e130663de6107c0effb12"
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
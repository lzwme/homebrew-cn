class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https:vfox.dev"
  url "https:github.comversion-foxvfoxarchiverefstagsv0.6.8.tar.gz"
  sha256 "f9408ce990fe613f1b9dfdcf860e0ef41cb179e7f75863bcfd90549ca3f4216e"
  license "Apache-2.0"
  head "https:github.comversion-foxvfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce037aa96c4b011ab0b9d59ba5da654ad421154057050e12fb21b99f67c85d12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2e389e67b5c7904105d2fe02d3b05e8e14088397ca09666ec2cac5e85c1773f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6905bd4a50ea94c49038e033f32f74d7941973d2519a566cb6d4aa1a4f103a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c3f318de416f12988604cd8fd2a20f45f382f64f6ea0daeebb0bd96f3a66b2f"
    sha256 cellar: :any_skip_relocation, ventura:       "33ea82687339da557483700176541ad33cffa59525bf38ba43d953f2e6f54008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6b50794f27d6b7ce5be22370ac63c2331bb4be9d4ee0fb2442a702dab26df5f"
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
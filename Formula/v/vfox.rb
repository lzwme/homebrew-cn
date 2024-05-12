class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https:vfox.lhan.me"
  url "https:github.comversion-foxvfoxarchiverefstagsv0.5.0.tar.gz"
  sha256 "36d91155d539e9267dceb7b9e2452c478c1ac38b8653096219ca0e7d33ea584a"
  license "Apache-2.0"
  head "https:github.comversion-foxvfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f6866ede93635ae0a2fbb77fc499deb256c50e794aacfbd0f153a4cff971623"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d28f182fbaaca0cebbe19bec78af4b4c9df7f834772035bd720e1312f1a576dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a530816ee737939850b7e2a4a2b77b102aa992a0bc6eb3a1137e8309e02c0db"
    sha256 cellar: :any_skip_relocation, sonoma:         "e418f98c0275df91b25842df85240ff6bc330f498b63feeade296eb9499a740f"
    sha256 cellar: :any_skip_relocation, ventura:        "a7163c87b448369b5c71c08373d0ecfe1c30c05f7582a14a75b5accd087e6fd0"
    sha256 cellar: :any_skip_relocation, monterey:       "2e5080e4d4f414148df8cd79ec9f2591a760c573e043214519d907913cd23829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "899f3812609584446d3e505eef0daa89cd86eb9a8a967268065647654ae4ada3"
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
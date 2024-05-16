class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https:vfox.lhan.me"
  url "https:github.comversion-foxvfoxarchiverefstagsv0.5.2.tar.gz"
  sha256 "d9c96154f1ba815eec3a22cf4967bad73eee69214dab83f79a587a9e908cac9b"
  license "Apache-2.0"
  head "https:github.comversion-foxvfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fa999ea55921ef4f78390c6fa869174b45bf61e78717dec0b619800b1580e56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8a9a2afe4f805d2fcac69b672f24a9be8f695c9e7a7efa6707f17f5f01d226e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c33ed80a10c805bf30b7fd1717779b6ee106edde1955cebdf73259c5185c6f77"
    sha256 cellar: :any_skip_relocation, sonoma:         "d895b3fb401d96b743336774c45207bd5eeae7e7f451c623353cdba17ce65006"
    sha256 cellar: :any_skip_relocation, ventura:        "44eb54184fefab7d27653b228214b5e87e8527e6ed523f16a8acecbf982aa835"
    sha256 cellar: :any_skip_relocation, monterey:       "8a982ba5c2f39bbc30c32cc455ce749497cdd1e19e14082b1c463fb3a47ad6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e548213815e993a42c1f477519ecd23d170dd083daeb1fc2558890f90218e693"
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
class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https:vfox.lhan.me"
  url "https:github.comversion-foxvfoxarchiverefstagsv0.3.1.tar.gz"
  sha256 "789cae4218a46ff1aeadf22b94c0b8ecd394088f0d3440e7c58293d4e53219b9"
  license "Apache-2.0"
  head "https:github.comversion-foxvfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe01038811a8ef65a3e2437f51f6fff764e8c730ba83c1a26de313404fe877c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1286848444548ae83cb079fc8bcbb5060de3864e8facbaec34ded9973a58b5e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec0b36a19db641a755ae1cfb7291c5e0269f995671493c6bd5deacf570b23b5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4246ccb932ebb9a2ae2e0e01c77963f2bf7996f12121a5641376cfaf1870311"
    sha256 cellar: :any_skip_relocation, ventura:        "899ee52b9b44d9853dd31f2fcfe2cf1a78577687c009c53e0be97e96d482f632"
    sha256 cellar: :any_skip_relocation, monterey:       "2c7a4971da76574110566393fb30fb5dc2d828a9c5e649ef515ccf35984b419a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15dc76cb87ad94cddcaeb41a8de64e73ad655ee5f3ff31d36ae63ab6f6419cfd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vfox --version")

    system bin"vfox", "add", "golang"
    output = shell_output(bin"vfox info golang")
    assert_match "Golang plugin, https:go.devdl", output
  end
end
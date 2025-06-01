class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv26.0.5.tar.gz"
  sha256 "1145d4b8fac36a0b99f7a2e69530c02b9008a84c844c182c26f626ea2056f472"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fbdd29f78012d8956d84664f6af8a01d1617e49a64da30f0a627c5dc000c2b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3d0a4d7c1791a96f6f5bf07fbb8c424cefe5f602a793ce281e339af6237777d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4ecd84b8efbca5c2c5d577a45d635d54801282920c95dac2d0aa8092891d659"
    sha256 cellar: :any_skip_relocation, sonoma:        "090310eb47ca65b73e1ff45c21b923da670f65f5f3edb2b9fde0ca3e739082e1"
    sha256 cellar: :any_skip_relocation, ventura:       "1796f94a2447c0b4a0f9c64916aac8125be29e0ffb721e5d1de9594f1816e2ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45cf865faa2c913f4cc6aab7b0c24a1fdc15b535d9c3efe5febd6c3154e0fd61"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
    output = shell_output("#{bin}oh-my-posh init bash")
    assert_match(%r{.cacheoh-my-poshinit\.#{version}\.default\.\d+\.sh}, output)
  end
end
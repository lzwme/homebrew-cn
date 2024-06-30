class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https:github.comnumtidetreefmt"
  url "https:github.comnumtidetreefmtarchiverefstagsv2.0.1.tar.gz"
  sha256 "2b0e8d1ec0bcf8cefbdfb41c98fc325d274e35a81eca2e3eddcb2c0d76ca2b06"
  license "MIT"
  head "https:github.comnumtidetreefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4aa363f498de85133ba7f72de6d224a2fb0c71c2973d7e5c332a04d24dab5504"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a6c29b801cfaa91308b42840ad45c655a6cd9017c24e412b373dbbcd0013605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f22483187b118d620cb0dacae5b3c9794327ef585c55740f6626bf69c43df09e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8cc08f258a0dce085495e14861a0a0cbf65098ab42339d4282a22f3b8f1e5da"
    sha256 cellar: :any_skip_relocation, ventura:        "530692b89732834e3cafc4ad418be72ec854c8034e8f076a814da1d69dad6a6f"
    sha256 cellar: :any_skip_relocation, monterey:       "0ab26d66f6f4cac8fac43374304888ceef1099d5757986576ade6c3264c47d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d532b19c2b40870e1a7af7997989e14ee5368a9a0e4921f59ef15ed025ab5cbc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X git.numtide.comnumtidetreefmtbuild.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "error: could not find treefmt.toml", shell_output("#{bin}treefmt 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}treefmt --version")
  end
end
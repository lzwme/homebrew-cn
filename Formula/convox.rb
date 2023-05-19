class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghproxy.com/https://github.com/convox/convox/archive/3.12.1.tar.gz"
  sha256 "557029adce1cf034259302ce9f6456aeae2682f193ef8c96c81719024d222723"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11fdc8a7bfe6c3da3e65fc26415ec3cbcf0169959e1ac8e4df3186142f142323"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dc3839898c354842ded4189e080949d38b1b1e655b3b99e582f410aabb3f123"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ebf35d3e96c5eb85f151eac79d530f8ecba9ecdad4056b6417c277d78804995"
    sha256 cellar: :any_skip_relocation, ventura:        "fc9854a0abe18748d5013f7ec18334c16badc06252ed3ca2f3f5b7b4a87fafa3"
    sha256 cellar: :any_skip_relocation, monterey:       "87af3c621ab4ddbd9a1aec7c4fe8e4972df154ea930ed24b7570a7cf41d3ce97"
    sha256 cellar: :any_skip_relocation, big_sur:        "52a2a97b0e554ce299eb8c0632901a424f4c4a0a016e0697435394a9c316d8d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e12be0cc3524d1b07be41089c7c640539c1097a439f3530f01eb39a880d80f0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
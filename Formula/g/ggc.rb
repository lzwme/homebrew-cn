class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "8cc3288a72a079ebd812f0ebb1431e160d3dcce7a2f2506c7ca2ccd3737e4483"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fbd5361d7bce7e997800f41e1d2dbf17539e50244c7f97f2b0e7fc5ac6cc262"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fbd5361d7bce7e997800f41e1d2dbf17539e50244c7f97f2b0e7fc5ac6cc262"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fbd5361d7bce7e997800f41e1d2dbf17539e50244c7f97f2b0e7fc5ac6cc262"
    sha256 cellar: :any_skip_relocation, sonoma:        "62ef70af9842d3b8e7af5b221653c3549c30b2bbf0c1ea56913b5e2b9fc86ba2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbe28620cef34395a62cd0334ea1f9407eb22e030dc735d3ee02ff660c27a56d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78b37423f77b006cc1db779608221658276c6a0769a5d012c17bc6a9fb648f89"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
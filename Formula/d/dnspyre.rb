class Dnspyre < Formula
  desc "CLI tool for a high QPS DNS benchmark"
  homepage "https://tantalor93.github.io/dnspyre/"
  url "https://ghfast.top/https://github.com/Tantalor93/dnspyre/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "04241da9b4b6320dc279245baaec0d49d614687c1799143b1e38e2b95dd603e4"
  license "MIT"
  head "https://github.com/Tantalor93/dnspyre.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80fff54f29d2dead5ac28ccbeefa10b37b97f39e83aa0384b28a04ee2661cf53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "531db69466da5a03ce898a5c5a443b3e49af770f5f2d476874375e53b1b3ed91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b917a858b36b46c6f6cdf22084e9ae432680dd6cc80a9c2b1d3f89ff1fa6e485"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cf702e98e50dbb148c469f5af7bb9f9f35ae98e5fab319e82eefe9584310e03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cae3cf4b7552fe68862d04f496e22d8eb7e516210d23b214aa5dcb3fa6073d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d68c4dded1892f1b47db418eeab63512afba67af45f474a4dfedc3411d0e91"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tantalor93/dnspyre/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnspyre --version 2>&1")

    output = shell_output("#{bin}/dnspyre example.com")
    assert_match "Using 1 hostnames", output.gsub(/\e\[[0-9;]*m/, "")
  end
end
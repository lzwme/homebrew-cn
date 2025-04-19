class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https:aquaproj.github.io"
  url "https:github.comaquaprojaquaarchiverefstagsv2.48.3.tar.gz"
  sha256 "0b5dd5d29922270e86449993a44f0625360debc83878e17330f375c2d0c4014f"
  license "MIT"
  head "https:github.comaquaprojaqua.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1470bc6b5c68d0fc3d007a7a3c3d3917f57a039e084ecef1dac58135eca7bff3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1470bc6b5c68d0fc3d007a7a3c3d3917f57a039e084ecef1dac58135eca7bff3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1470bc6b5c68d0fc3d007a7a3c3d3917f57a039e084ecef1dac58135eca7bff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "991a8d86ada805585a017105516be05c775aab6788481620b239e7eef9437406"
    sha256 cellar: :any_skip_relocation, ventura:       "991a8d86ada805585a017105516be05c775aab6788481620b239e7eef9437406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46f81b95bf122b7c73f7585271040cff5e718455b04819b979a7eff42db52a84"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdaqua"

    generate_completions_from_executable(bin"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}aqua --version")

    system bin"aqua", "init"
    assert_match "depName=aquaprojaqua-registry", (testpath"aqua.yaml").read
  end
end
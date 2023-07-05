class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://ghproxy.com/https://github.com/nginx-proxy/docker-gen/archive/0.10.5.tar.gz"
  sha256 "fb9c22563e1b7c87020633c4c4ea240d2e4b1c1f82d55c8e2174b4a5835c1c7a"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c5b883446f6e467d5010e425b505014d098453657275270635d62e716100367"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c5b883446f6e467d5010e425b505014d098453657275270635d62e716100367"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c5b883446f6e467d5010e425b505014d098453657275270635d62e716100367"
    sha256 cellar: :any_skip_relocation, ventura:        "7799d7f4b5a3414877a68a00db22c7f2faf1909b56ed1fb9fa0810b289d84694"
    sha256 cellar: :any_skip_relocation, monterey:       "7799d7f4b5a3414877a68a00db22c7f2faf1909b56ed1fb9fa0810b289d84694"
    sha256 cellar: :any_skip_relocation, big_sur:        "7799d7f4b5a3414877a68a00db22c7f2faf1909b56ed1fb9fa0810b289d84694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b185fa9b46613fe670c181f8753a22638adccc0fd548230774cf7b74a402caee"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://ghfast.top/https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.15.0.tar.gz"
  sha256 "d42b02c11577aca112efa7e5ef3cb011e5355e9b3ea2bc753eb6a1a1cf1177b4"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a28abd94ea7f44fb7ed070896de922856e82bac3116a8c18497f6ba6c3ae721"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a28abd94ea7f44fb7ed070896de922856e82bac3116a8c18497f6ba6c3ae721"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a28abd94ea7f44fb7ed070896de922856e82bac3116a8c18497f6ba6c3ae721"
    sha256 cellar: :any_skip_relocation, sonoma:        "de01397491f6e4294faae9079898163fa5a736eecbf771f89139149d8d9bcb90"
    sha256 cellar: :any_skip_relocation, ventura:       "de01397491f6e4294faae9079898163fa5a736eecbf771f89139149d8d9bcb90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d76fb5f0081805f4fde2ba126a8d875d190a805a96e3873d358528ba5d7315c0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
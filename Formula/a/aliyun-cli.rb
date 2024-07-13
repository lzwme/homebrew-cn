class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.213",
      revision: "b96e1c466706f77fda7b6fa147625a16ac9dd85d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8744e92a6cad1979fa4537d81c753fc89a67c2ffffa9bdf8efcb88006e700a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccb1ba94157617a31216f2300dcb1ae2a742efd07263dc90bf8135fc7b130ca1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f15ed6fe90fae0525a6601968394cde57148df5a3cf499882ce713f88dca2ce9"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d1c4c43ccca849e3ef79d8ddb5b5f9fa472406995cde9c1affc71b500349b99"
    sha256 cellar: :any_skip_relocation, ventura:        "c40d2d1a211f0e7c7a3d27a357c1caa5931666d668b49e39096c9b6606fbfdce"
    sha256 cellar: :any_skip_relocation, monterey:       "51c495f5512c65c5938fdeb57236f2ca9e7cdac3f4b8734cda4b9fc12ffdc1be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d2b09fcaddb1f5c773509b6054fdc7a612f8b7230a19d6c3f4755a237f73181"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-clicli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin"aliyun", ldflags:), "mainmain.go"
  end

  test do
    version_out = shell_output("#{bin}aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.8.2.tar.gz"
  sha256 "07bb30547f4875a07ff8fd4550bc1be67c1139d2cf1ed9eac67b8c8691398516"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9872ce52d99a486f62fc50da51d8e8d0adc3d00a7517637d960ae8a9200d7e4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7aadc11e6cbed19ddb9746dec06a897ad2039189327ed2602502ea9ec2c7477"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef72c7fcb4c50209f69d4f73aafe7723fe4d177ee91cd870e2d4538c81708cbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "86cff09a959a395eae13342c03516bf4bdc32612ec6bdc551bdeb4e0e1003cfe"
    sha256 cellar: :any_skip_relocation, ventura:        "6088769cb7f925a5e5e75a4381c3c14c512acc2ea2afebcc6079ed79829f81a9"
    sha256 cellar: :any_skip_relocation, monterey:       "183804e53ade2512c705fa55e7304ffcbd48966e00e6e1751621942f38fa9339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "967599f1a7a26806fb9920708e21d290b07257994b28b3113d2882c355347c6e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end
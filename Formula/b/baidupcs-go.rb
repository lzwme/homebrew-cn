class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://ghproxy.com/https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.9.3.tar.gz"
  sha256 "e560b1a977fda5e4d3e9e67df5ae8eddd45ed0bf9f9e65b604afe06aeed8a1c8"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f278f9b0c3f5286084ff43a432ae91db6390814620c9b3f4284ffe7f988dfb64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f883c13f897a9788d52f5972f3079e9e4b0e32ef6cb27933e823b148dfc94936"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30d536cc4d681438ef3170e9a1c14d57e58044d974e615e0cd7775baf91c4725"
    sha256 cellar: :any_skip_relocation, ventura:        "a812c990e528a0d5885866a648f1f179d621ea1c2fe782c5f401bea178b8af27"
    sha256 cellar: :any_skip_relocation, monterey:       "322841c4c0fcf526be973708481ade6f05ac300368c3929a5804a9de70c3d6db"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca6c4ddf8d987c55f6c9f65712bbbac60106158c838b4a57a61210ffbc75aaaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "023375a3d8fc635316329338e3671e55f64137f16d96381985afbed95ab7e4d8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_predicate testpath/"test.txt", :exist?
  end
end
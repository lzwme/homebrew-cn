class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://ghproxy.com/https://github.com/cloudwego/hertz/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "2fc3d721efa23e12b3f7a168b3d54d0b4301ccf34fd1cdc63b8c6b30a1a0c98b"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed7731688eb9686f6f1ebd3d993b51027b75a02826f16510da623fdc68faffce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c570eba9712d2f5a3012d418f6400a463f9d2549ef6fb39b646ef8599d5c381d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1e00d677eb366b91f8ceb3c085346eeb4d66c0ce788dce810dff7389e2d7570"
    sha256 cellar: :any_skip_relocation, ventura:        "e6ebcac5fb9a3d70005e134d7c7b2b7e6575f2d2a3aba92de4e2202da2713085"
    sha256 cellar: :any_skip_relocation, monterey:       "b43dd296ede1399e0e815036e1067814ca8add5096122cadb867d8ba1dd3881b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f9b481c58964d03b3b3d65ffe3dadf0fce15b1ac4b199e96dfb38aaf77f8850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9f43a9bfed9d61729109c8d702cec19f0bb99efb72d410ef477c00c507e7aad"
  end

  depends_on "go" => :build

  def install
    cd "cmd/hz" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
    bin.install_symlink "#{bin}/hz" => "thrift-gen-hertz"
    bin.install_symlink "#{bin}/hz" => "protoc-gen-hertz"
  end

  test do
    output = shell_output("#{bin}/hz --version 2>&1")
    assert_match "hz version v#{version}", output

    system "#{bin}/hz", "new", "--mod=test"
    assert_predicate testpath/"main.go", :exist?
    refute_predicate (testpath/"main.go").size, :zero?
  end
end
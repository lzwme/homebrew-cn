class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://ghproxy.com/https://github.com/cloudwego/hertz/archive/refs/tags/cmd/hz/v0.6.5.tar.gz"
  sha256 "49e64d68e4a0da4c6ef799cd7a4b6567c5d37b79d75ac8f6897176d1ddf42bd7"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  livecheck do
    url :stable
    regex(%r{^cmd/hz/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "969a5aa423495f803655ad5e45fbf7e3837a6463f37a41188fe959706b594640"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "969a5aa423495f803655ad5e45fbf7e3837a6463f37a41188fe959706b594640"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "969a5aa423495f803655ad5e45fbf7e3837a6463f37a41188fe959706b594640"
    sha256 cellar: :any_skip_relocation, ventura:        "bd8b960e437ddaede8aa2e541dbb00d2c7e6e14fd4d4847405b7004df0426824"
    sha256 cellar: :any_skip_relocation, monterey:       "bd8b960e437ddaede8aa2e541dbb00d2c7e6e14fd4d4847405b7004df0426824"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd8b960e437ddaede8aa2e541dbb00d2c7e6e14fd4d4847405b7004df0426824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa1b5d6ecc42a708514de9572daea24d2a01efa94a2bcb80e875e6b28e7d1fb1"
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
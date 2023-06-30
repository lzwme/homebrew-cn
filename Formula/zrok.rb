require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghproxy.com/https://github.com/openziti/zrok/archive/v0.4.2.tar.gz"
  sha256 "35c3630912bb21c655dcdb4d4be4f63c14e7ceaa80736f57cf41fd3db25b893f"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c56743a7064edbd6013d946139457f0d3ada61d5c83c668bacdcbfec2ac9ad4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ecb763d3eaa1ae9a8e89fa86014f840a984572a17c67da99d434dfd3883a2d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67cb669734e33dc18128027b8e2666781eac43883a0e235aa93807213fae405f"
    sha256 cellar: :any_skip_relocation, ventura:        "0f3c646c87e825e7cdd1a91f7560930d3c749dafb069ad9cf61ffed97a532250"
    sha256 cellar: :any_skip_relocation, monterey:       "97b390235168cc8234910cd17e16b50b70224209d77dbbbaea51e383dea1ed80"
    sha256 cellar: :any_skip_relocation, big_sur:        "3df71811e0bb5a6fbd02803c950c098f0f9310c3452a5d08af50da4c5a738cce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "931ea7b0ff30b2f87123f35bd2ca19d3633601126e991926fed8f06261795e2c"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath/"ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    ldflags = ["-X github.com/openziti/zrok/build.Version=#{version}",
               "-X github.com/openziti/zrok/build.Hash=brew"]
    system "go", "build", *std_go_args(ldflags: ldflags), "github.com/openziti/zrok/cmd/zrok"
  end

  test do
    (testpath/"ctrl.yml").write <<~EOS
      v: 3
      maintenance:
        registration:
          expiration_timeout: 24h
    EOS

    version_output = shell_output("#{bin}/zrok version")
    assert_match(version.to_s, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end
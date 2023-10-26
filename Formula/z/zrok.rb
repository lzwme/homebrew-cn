require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghproxy.com/https://github.com/openziti/zrok/archive/refs/tags/v0.4.13.tar.gz"
  sha256 "df07627a52c615e120ed66057472be5484a9c2b6c2006add6bd44d12642f6802"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9469868cf587a2dd68c3f5632fc7fac402b6fb91ddd1c659ee1918153cd0d4fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "755c3032c157779e8a667c208449da3e81808473fed4a1ca28b3fbfdb3f91886"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03742fc67308d62b0128be6f90b0e383935d08900a78ff4bc3c9faa2b8b9dc92"
    sha256 cellar: :any_skip_relocation, sonoma:         "88602ae837b816b7ee5ec72de6d40e2fa632de80fc0691ffacdaa0a1873f89d0"
    sha256 cellar: :any_skip_relocation, ventura:        "59d8ee861485cd253d339d75c33c0c557362a1689ff47204fdcf1dabe780463e"
    sha256 cellar: :any_skip_relocation, monterey:       "f5071b53d8529e7a339c0f0ab1ac015e21c0707379cac4485266fad18666f503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba0c85cb449dc6dd631c9cb2854f2e7f2cf576b95ec4f99b5ce13d616905a6b6"
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
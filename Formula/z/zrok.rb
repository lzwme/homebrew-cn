require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghproxy.com/https://github.com/openziti/zrok/archive/refs/tags/v0.4.18.tar.gz"
  sha256 "3e5534dafd56c77ae81fd839b2edc122d8653150ff2cc0226d5c0a78f80fbabd"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddd2e7d1876998d03004282f7866bf26cc8b9aee7d27bd88f366008f0d71e1d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a06721ef8a9c01c599276a49e39f4e62879cde40f25f77cb326835b022c83a12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "395ca5a07d3d69443a2f6d392baf51b9dd86fa61c8c8e143891384528480c28e"
    sha256 cellar: :any_skip_relocation, sonoma:         "67937776135f0c1ce79c750b0e442356b4da933b79a4747fc58eb1c6e99a6f69"
    sha256 cellar: :any_skip_relocation, ventura:        "d986857c1163c848c83d59adcb1bc28e45ea34652cf658a36f9ba23a009b2e3e"
    sha256 cellar: :any_skip_relocation, monterey:       "e08097e1a4064e4f0c75319b11a2fd2af6b9a2a62a8a69eeca844c589152905a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "095578506d8c37299389037993727754cc87097ee7493b6ee8caa31c008d8cfd"
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
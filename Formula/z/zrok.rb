require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghproxy.com/https://github.com/openziti/zrok/archive/refs/tags/v0.4.19.tar.gz"
  sha256 "636c6a7aaa6a77ba19613f6756beef729212fe99c33ad5d3b39127387887cb9c"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "267f1a523b0c4dc8afd0a1a595e9bcfc32e97bc45263a528559d324f6eb47aec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d2999832f5c04af700f61ef50a832a8ab4bf8f0170ed8f6521d6e99127836f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2da7696d7731a01d62083f3201b0c3aa4ecbc47dbaea5b32c1bd393e7a803c31"
    sha256 cellar: :any_skip_relocation, sonoma:         "a51f02aa3bf85ee2fbe2436a2ae1a5d61e31d8eafa4319f42c45021c2b253b52"
    sha256 cellar: :any_skip_relocation, ventura:        "d0060f3298905d4febb8d3712dff3e8cc383417952b768f8848ad9347b7d1d1b"
    sha256 cellar: :any_skip_relocation, monterey:       "cf3e671c5c93b9ba2ef19f48df31f1eaeeb2292baacb075ea172b881892b9303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce3b1ac7396cfe7cc4256e9848c9b66150a344026b485d267598b75d69a2fbf7"
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
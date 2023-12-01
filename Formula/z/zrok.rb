require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghproxy.com/https://github.com/openziti/zrok/archive/refs/tags/v0.4.17.tar.gz"
  sha256 "70bc7f9bcc26518be242c84d58367b8284da132bc8774e8e2a217a69837a0d6e"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46b6c2e76c85a4484d819486eeaf2939264435ccac62b00fb48f740f8e9baf51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ea8a132b2ecd772fdb12ddcee1aa3a02d23af4ca9a56c4d5a3705b5f6551d5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "915723f67ccd4ebd637626c591bf5ca184cc21d5c2d88fb859df300859931b07"
    sha256 cellar: :any_skip_relocation, sonoma:         "632052572675e8e365b02273eef4319d511bc2a8df9337e443bad843165edfc9"
    sha256 cellar: :any_skip_relocation, ventura:        "f5c762fe9cb8fca7a24d84ebc2ade8dd050ea947c9b9e17a3f637c2d3234d351"
    sha256 cellar: :any_skip_relocation, monterey:       "7d47e88b643de5d2c4135f4f6112889bcd7bdc94a2b45e5ed3f555249bb6a60c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efb8e3e220ac176cfc3e5d27e62aa0aff2f2c3bc5b707ccce8d5eafabc3c7e8a"
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
require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghproxy.com/https://github.com/openziti/zrok/archive/v0.4.8.tar.gz"
  sha256 "340b98e74102ea0104795c54b12969d4554444e4ff3f87e51b0ef753c8b54dee"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc356bb8bd4c12d149610b6351baecbc7a6e1f758275274d6fa5db26af354be0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a0b32bfb7f5821210af903a2aaa7b28f3f5a3274220fa3684646f9999c3af89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9228a472fac7c8d57233f7ed31af7c60c48561f5080f5ecb18942cb48590918"
    sha256 cellar: :any_skip_relocation, sonoma:         "9707a8f68f6776c35f4770f3eea7ddd22564dfd0a43ebaff806d09c97a4b06a9"
    sha256 cellar: :any_skip_relocation, ventura:        "c40e792d419007167fc3959d3f45373756cbf52a6586f8a1c5a0effff492f015"
    sha256 cellar: :any_skip_relocation, monterey:       "cc5ad470533bcb91e48c2c276339c515d2f2305b2c1a7debf249636818237136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7c6f57d328ba464940b5330af6bb999e74f7396565268f20da072e4e9138f14"
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
require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghproxy.com/https://github.com/openziti/zrok/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "d0c37cff0e9f9ec8339e4d830f7a1a17d22c8e3536ffd9ea5a2bb37783d4a43f"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ca7733574a0798d19ba9e21012d7de576d79e1741033951bb4dd5f23c3e58c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3be239a8397897eaae49f69240c526269e72ef6edc4b5529323fe68da5908a45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95ccd022c891398072b00a0d07c74f1ed2353cfef5c3b66d438ed671992552fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "5455979dee9af1cd6c41356ca1b1873e4a841641a0c3fcad9532c0ef06d888cc"
    sha256 cellar: :any_skip_relocation, ventura:        "aefbc6c4e9568faa2c8612bceee234c77c424a75c547b3ddfbd4653f459e5b74"
    sha256 cellar: :any_skip_relocation, monterey:       "3e59e9d8bfbf221ad55bc5735b3c08c4191f229135a1a7b987e7578ab16598e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de4e769c95658a82d07e8b264f9aaee8eef8f9dfe0e9f549b952649db191e2f0"
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
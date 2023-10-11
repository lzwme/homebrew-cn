require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghproxy.com/https://github.com/openziti/zrok/archive/v0.4.7.tar.gz"
  sha256 "c42f8f730c791f506cdb80734e64672a3e10e59335a816db628b056c8ee4830a"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2852267484a7c63577ec6a660124e5e47c129f186136e86d4eb311da479a6864"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddafa67d51a9b92b253857eaeac6a044179536897c38ee3b919640b5e395206e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f89ec7a44ad1b3a7b2352da6dc006bf4961a0848cd4f781e35e509c241cffd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "8854afa4ed02949edffa2d860005c44c210b9f1ad13476f7cf7ac71c51c814a9"
    sha256 cellar: :any_skip_relocation, ventura:        "8ceef2feae592c485005bf736cf12059b677179fddca345a665bd959e029b335"
    sha256 cellar: :any_skip_relocation, monterey:       "c9fc181b709ad1b0fb084e4f5a57fd3bf6868b36f8dbdca375590aff789500b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29c4c1ffa7cf669be0b092d83f276e571c18d0d0f9808053f0e23e3262ee2d4e"
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
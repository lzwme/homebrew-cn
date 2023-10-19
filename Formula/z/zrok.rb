require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghproxy.com/https://github.com/openziti/zrok/archive/v0.4.10.tar.gz"
  sha256 "58c57c393be3d279a47453387df19bf91a0f998cb8dabbf0442baca376a22e4c"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc11ae7efec599dabe7079454a2d693d965eedb47e01dde997474479c2e06867"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38f5e17d621ba92adc185d0fa92b290c3825da9e87204c6bbfd2da3f32a02c6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44b0c8ff882d72df936b11c197ba4a11c98d049f4cb4aa83705183dddd1d1686"
    sha256 cellar: :any_skip_relocation, sonoma:         "743ff131529f5cd459f47fb45959b310e50c4421e85ab43417d106b0a0cab6be"
    sha256 cellar: :any_skip_relocation, ventura:        "6df2a7fbb615c23e27e0111141176900e13c15c88bad64c133cea0456e4b3a62"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b8a1060dddbcd108f67c4a9c19025aeac494d7df03d43e69bc0824111bfaf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "407afd52b80aa6aaee3f055726e8c3ede9782ad61d6a8abd6607ed9ebc0b7391"
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
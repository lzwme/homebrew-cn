require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghproxy.com/https://github.com/openziti/zrok/archive/refs/tags/v0.4.16.tar.gz"
  sha256 "4745de03fd5809805e8f3b5f21cdc37bc2e0ac0f23cf0b28b3745a1682be8559"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e67e92e29e810b2fe6d34dbb78ce8a08923a029a325f53713aaf1d156a85974"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d102d840cd18316ddd2b8c573bb54489154358d7dcffe3fd725e175b28730798"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d9e4bda87ee1d64b2ab4e07e71934ad61b9135099d9460b46902fd650705a06"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bbf9780c6987212b09fbfb6fa31598907820eaf0a69a32eda4d60c98621c9f9"
    sha256 cellar: :any_skip_relocation, ventura:        "27742acb928f390d78245f952a8613d08f4567b7b08e656ca2b89d961e9957c8"
    sha256 cellar: :any_skip_relocation, monterey:       "1a782707b3cbede8af8da9744222fb9abccea2a51d042835aa62225a5542e0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d04642651d894fd8d78abd47c3c2c442445a6660cb5835d5fcea2bffab739626"
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
require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghproxy.com/https://github.com/openziti/zrok/archive/refs/tags/v0.4.14.tar.gz"
  sha256 "a8ab797648d77c1cc32bfdc10e9d569ea6ba48d856e376dd01bc22a636573f58"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7cf6c793b4b9444138f72515911f539f125d46430cbfa038a9d813cf5931af5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cb70ff43b708d5ab0faf92ce851c0c9fb860873947559ec0de0df28987e52a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b0d7d5e6b4ad5874b186095faf3c141b7776e277ac577bd8ea1c2d052c34ec4"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb3ecf7109601b62d7b1b2c90f229843781a103ded1f2ab9145f5236cf4660e5"
    sha256 cellar: :any_skip_relocation, ventura:        "f5d51e96eeec0128599980efb0062b8a87b1091767dccc57298838accda73f9c"
    sha256 cellar: :any_skip_relocation, monterey:       "fda20c0065674dcccf007b0e9707024efa9db210de2eee2a434db669b51598f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4aee2ba6273e1b4b39938148febdd08444eb0c15b0ba99eab3d19db119e4046"
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
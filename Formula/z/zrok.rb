require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://ghproxy.com/https://github.com/openziti/zrok/archive/v0.4.4.tar.gz"
  sha256 "dca065422492243e0dedaf47350d7e52048ba9c78fa04bc5135761e3e4a7e2f3"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3088d47bf0170e3befc1ca28b8ca1f458997a528bb92ea3d17b4b1fd725edc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a664e51240f6390e51a26d97a35001ed1fb422bf2eb1c94e18a5bcc9d4fcd26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bddf25b9648effe4ca2c6b9a5be519f202208ea5e0e662330689f33bd6d0d186"
    sha256 cellar: :any_skip_relocation, ventura:        "4a809432d8148c5d0c41498f47e5eee94eded4dd2d123e473df5bb9403585479"
    sha256 cellar: :any_skip_relocation, monterey:       "8d3ab5c086128df54fd1d50e260f23a7b455dc64029fba62bca5110012c4567b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4aa4e19bf5cc376513c8659e17a3e4d8f59c8e118961c1e912ce3337761f752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fbfe7bb3098819e739fc3b20737ef77e2f0cc3b0fd252066c8b2756442e2fa0"
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
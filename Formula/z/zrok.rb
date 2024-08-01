require "languagenode"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokarchiverefstagsv0.4.38.tar.gz"
  sha256 "d1aaa8b879200400cfa70ecfd2aceed698d51f55fc6dd1625de9254cfb2a92c7"
  license "Apache-2.0"
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c43ae0c5d5b3ba50e9fcc2a8841e8bb47fb5f9d3f5d5f122d71df82b8313d5b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f19ec6fc4e560ae0581a85f5591066d7e6acc0ac31ccd114e9bdf057e25549e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4bd2a67a441e255a4af0b7b7905299e5944f0c1d5e553911fa3eef05d092670"
    sha256 cellar: :any_skip_relocation, sonoma:         "29b3c31526c36085d41bbe68f6e304e485ab4cb3363cf5d71703086965479c20"
    sha256 cellar: :any_skip_relocation, ventura:        "ef73a457a7dcc047d491464c1716a6ff41341925715c2cdb8b830e8c28a48fb1"
    sha256 cellar: :any_skip_relocation, monterey:       "cc5ddf708c08cf15f4fb5ea26406b6eabddb6dcd274d87923d2fab4163c2dc6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9202549c80e7f945bdfc05e14f60482080513cecf68700832f51b694e8a3c958"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath"ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end

    ldflags = %W[
      -s -w
      -X github.comopenzitizrokbuild.Version=#{version}
      -X github.comopenzitizrokbuild.Hash=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdzrok"
  end

  test do
    (testpath"ctrl.yml").write <<~EOS
      v: 4
      maintenance:
        registration:
          expiration_timeout:           24h
          check_frequency:              1h
          batch_limit:                  500
        reset_password:
          expiration_timeout:           15m
          check_frequency:              15m
          batch_limit:                  500
    EOS

    version_output = shell_output("#{bin}zrok version")
    assert_match(version.to_s, version_output)
    assert_match([[a-f0-9]{40}], version_output)

    status_output = shell_output("#{bin}zrok controller validate #{testpath}ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end
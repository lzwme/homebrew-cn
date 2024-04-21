class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.9.0.tar.gz"
  sha256 "c39e10a1e475dc21ae6ed64be0f7b7be51f9dedb7c017aa9f70299d45915cc3a"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8512ed975595daf47eecb11fa2e9601babb235a0c9985befe0594175e4f8282d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e345f435e027f24c38a304a016cd6d2c26f5801a933ec387c6c8de4bde3f4332"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7be86f0e7da9575df23cc080c4879a063f1467450b1c1dc6da90dd2ed36a2421"
    sha256 cellar: :any_skip_relocation, sonoma:         "76e0ccb35dd93d702846a35469e97bb1f314a7a62c08b89ba17d8101ca745b8d"
    sha256 cellar: :any_skip_relocation, ventura:        "bea291f628f3b350c85a03dde33e833e11ab6122d909fdb806ec572903bf5ba2"
    sha256 cellar: :any_skip_relocation, monterey:       "6da3717c47ba48bcd547f3db6f996ad6984392fc2d59855858d78f00320d905d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7697b559713b046ddaf29ca2e1b6433e35d5515696bf163cec7e25710b546f5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".corecmdhoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}hoverfly -version")
  end
end
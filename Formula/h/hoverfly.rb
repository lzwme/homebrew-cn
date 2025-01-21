class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.10.8.tar.gz"
  sha256 "9674aee1ae2b32552c44c2a8fb520b838f5340ff7d90bf94f5a7ddf5df6d44d4"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af5ee69a29491fe9c2f44100ab74919e5ee9f45308dfc937e8461f08f1312075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af5ee69a29491fe9c2f44100ab74919e5ee9f45308dfc937e8461f08f1312075"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af5ee69a29491fe9c2f44100ab74919e5ee9f45308dfc937e8461f08f1312075"
    sha256 cellar: :any_skip_relocation, sonoma:        "96079d6d3345b1baf0a22e27de801802d9e2209b8cb2c0ad198c507d72c1ecf7"
    sha256 cellar: :any_skip_relocation, ventura:       "96079d6d3345b1baf0a22e27de801802d9e2209b8cb2c0ad198c507d72c1ecf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d9b61e5283c4f91d75fec58f05a837a9bae3541ef9725845ca7032da6f44c25"
  end

  depends_on "go" => :build

  # version patch, upstream pr ref, https:github.comSpectoLabshoverflypull1171
  patch do
    url "https:github.comSpectoLabshoverflycommite4aae6a3fa53acb444e3fe12ae2ded1c1ebb915a.patch?full_index=1"
    sha256 "2b31220b440026f8e6a616760ff1eb67b58cc5dac73beeaa6a2c5a1eb6a18a99"
  end

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
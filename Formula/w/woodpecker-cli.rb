class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv3.5.0.tar.gz"
  sha256 "618a3297485c67a4c942e11ee4dfd9db8b5b2ecc340e2f47b59301f3d9e32ab1"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fe1ae2bd3048a171d49d1d1c76da282ed81a84ac05dd14fc3fd030722b4bbbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fe1ae2bd3048a171d49d1d1c76da282ed81a84ac05dd14fc3fd030722b4bbbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fe1ae2bd3048a171d49d1d1c76da282ed81a84ac05dd14fc3fd030722b4bbbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "38e71333a44d3708a61a229a7f674cc058c07f8dcb4373d51f08746c2cc8df34"
    sha256 cellar: :any_skip_relocation, ventura:       "38e71333a44d3708a61a229a7f674cc058c07f8dcb4373d51f08746c2cc8df34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be91d086da25cbd17e3717c11c3cf22e5cd79881e174ec0b856727c1ef6ef533"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.orgwoodpeckerv#{version.major}version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"
  end

  test do
    output = shell_output("#{bin}woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}woodpecker-cli --version")
  end
end
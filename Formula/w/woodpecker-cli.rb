class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv3.1.0.tar.gz"
  sha256 "4ef1034d25a547380aecf491b43c3fc214b7940c19cb7d7cc763ac87dcbb6438"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15223fd4ce2e74a88d96feaedb47d4f6a101423340fad8533d482c38eecc7849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15223fd4ce2e74a88d96feaedb47d4f6a101423340fad8533d482c38eecc7849"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15223fd4ce2e74a88d96feaedb47d4f6a101423340fad8533d482c38eecc7849"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdfe9e97f5a6f468896d834ace51e55b27a0ecdd09916aa3d781dcd4b7203b54"
    sha256 cellar: :any_skip_relocation, ventura:       "bdfe9e97f5a6f468896d834ace51e55b27a0ecdd09916aa3d781dcd4b7203b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da48c40a761f6d61fe4283b92ecdea999a17547570071c0c66cd3fd3ff93b1d9"
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
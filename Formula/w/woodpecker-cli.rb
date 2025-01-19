class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv3.0.0.tar.gz"
  sha256 "983d03472229b581eb73efe43d44bba87ef0c4aac79640c6e60048270279cb26"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e27574e11d8ab51417f5b9acba6bd5507720c2d44cd68388a9ef437126c5934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e27574e11d8ab51417f5b9acba6bd5507720c2d44cd68388a9ef437126c5934"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e27574e11d8ab51417f5b9acba6bd5507720c2d44cd68388a9ef437126c5934"
    sha256 cellar: :any_skip_relocation, sonoma:        "45c72eef4c547f757eac32fe2164b926d1825c2a3f5d6c27db13520559824a22"
    sha256 cellar: :any_skip_relocation, ventura:       "45c72eef4c547f757eac32fe2164b926d1825c2a3f5d6c27db13520559824a22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffb185cb008473063edde4087dc8ba5fa23fe65cb288d6c32ce259109f172d77"
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
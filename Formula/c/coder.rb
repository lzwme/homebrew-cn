class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.14.2.tar.gz"
  sha256 "6b72ce938da7f273f9371d164233457de6cb360dd42ce38a4d0f585d71fdce78"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96fb3a0e861fe256411b737cdc9d352642b921aa7b497023d9ac6a1b3048b7de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ce94911848bc7a9f109346f8d37cb25a5e7d234169170d7433628ee6482f576"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94caa5044edded16e326a5448672e1a387744b2209b148023e565ce7dfca5a77"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fa60a3c444e0dd759318d445678356da69b5d90a28d6221000784570429ed3a"
    sha256 cellar: :any_skip_relocation, ventura:        "8d0ff986a20b2e2e1c34baf5b62c38695245294f98888306c1765eb1bb9a8bf9"
    sha256 cellar: :any_skip_relocation, monterey:       "29bdfb3354fe31cc246f9d989c83506f5a9fc24ea2760a1309570936c62bdd09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99c99b659b923ad2980541d1ad2777cd8579a6539d6b67fb434dd2ba9da99c8f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end
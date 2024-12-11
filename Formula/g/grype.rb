class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.86.0.tar.gz"
  sha256 "44b777eeca3127cfe08007fdeb0a7e7f7b1b268eb224b0993e82eb6ab8fd77f7"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea6ea374b9a9f71a707cbe944b3ba11d0ab30f9df1a62c32d59334e4dfc81c56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a450aebe59f6a0f80f51cd9c209e063862401b68744cc8d877d5d174a54e073"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79d7233181f01b565fdfadf0394985f2c91e7d5c1dabf86f7ea638b803de4f57"
    sha256 cellar: :any_skip_relocation, sonoma:        "0be1990d919a2f875e9c7f141131025e18a81e8077048d6efb321de89fb77d34"
    sha256 cellar: :any_skip_relocation, ventura:       "c7cf6bc476e0ff65d8bca80e10702ea3d6bc772fd95f413b739058d1833e84f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ce37696bc7c26418cc1a7165a75d345cd29a20dc2720dcf6c4429eaebc3f8f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end
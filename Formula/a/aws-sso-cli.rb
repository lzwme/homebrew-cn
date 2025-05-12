class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https:synfinatic.github.ioaws-sso-cli"
  url "https:github.comsynfinaticaws-sso-cliarchiverefstagsv2.0.0.tar.gz"
  sha256 "8a994f14daf5284fcbe6112c0d224e033b8e737c1dfcbef234017a2abe1ac4d7"
  license "GPL-3.0-only"
  head "https:github.comsynfinaticaws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b9fd58bc39c986a20efc08e5df37994681bf3dac203ffb46f1f339259380879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d492eace65bc2fb63751ac9295d23deb58b069c839c4a9bd4ae34a365296785"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a05fc92c44cfecbf666d53eece42ca995f7843172557622c450d4f7faadc15f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "11bc8478f9d2ac373265949e2b55fb3e8178fe40ee55386d4b2d07b19e16edd5"
    sha256 cellar: :any_skip_relocation, ventura:       "0c7d6289c62d9ecd13374c0a8aa89c05d59e0bc2a3400a4c4d21d2139b8bcac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42866f0177ad09637c6fd11c92e9035a35ecdb25e949de3a73e2e6ac63e52e80"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Buildinfos=#{time.iso8601}
      -X main.Tag=#{version}
      -X main.CommitID=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"aws-sso"), ".cmdaws-sso"
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}aws-sso version")
    assert_match "no AWS SSO providers have been configured",
        shell_output("#{bin}aws-sso --config devnull 2>&1", 1)
  end
end
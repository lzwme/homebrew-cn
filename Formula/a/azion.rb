class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags2.3.1.tar.gz"
  sha256 "871e53419cf39c41616f106b35f8489f23578393961a48174bd9c12c9ab0a76f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "066c8853ceb9e6a25237ce4305fafd0fe649de6828aa6317998a269ce6317877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "066c8853ceb9e6a25237ce4305fafd0fe649de6828aa6317998a269ce6317877"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "066c8853ceb9e6a25237ce4305fafd0fe649de6828aa6317998a269ce6317877"
    sha256 cellar: :any_skip_relocation, sonoma:        "2187b931b5a991b4a9389d3878d5271bdae42f0a338248147c077e0b45b9e578"
    sha256 cellar: :any_skip_relocation, ventura:       "2187b931b5a991b4a9389d3878d5271bdae42f0a338248147c077e0b45b9e578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ccf0a097d0d6cdad8550bad611d34380b6aa80f70493d2dbfb479ea29b85b81"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaziontechazion-clipkgcmdversion.BinVersion=#{version}
      -X github.comaziontechazion-clipkgconstants.StorageApiURL=https:api.azion.com
      -X github.comaziontechazion-clipkgconstants.AuthURL=https:sso.azion.comapi
      -X github.comaziontechazion-clipkgconstants.ApiURL=https:api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdazion"

    generate_completions_from_executable(bin"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}azion build --yes 2>&1", 1)
  end
end
class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https:github.comhickfordgit-credential-oauth"
  url "https:github.comhickfordgit-credential-oautharchiverefstagsv0.13.0.tar.gz"
  sha256 "88cc45fdd5d70cb0474e3ab791ab17e8760fb1745568bbbc6de1668a37a3d843"
  license "Apache-2.0"
  head "https:github.comhickfordgit-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f146efc4441169c965212edbce7332aefe41c55c593df5e20030db0fc6fecfa3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e299d1f9daa4c9588288bf6bc46ec4a4463950212cb48867bade044e8afa575"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b056194cea7a2a70fb9f2c18fd5190a8e413e791d135264a4e2248a6b2c90750"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f26758abe3b4ed345a61193d702cf3a747c5888a85f848d2787c4a811078b00"
    sha256 cellar: :any_skip_relocation, ventura:        "ca913d7781db4282492f496a68103e7003b13c89275cdb0cc741814870d30bbe"
    sha256 cellar: :any_skip_relocation, monterey:       "5784a3d4de6280047225c3479f4cfad263aaff5f43f4d7988b21589615a9000f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07e0eec96d4d11d746b56f3bbd899b07e83786d2a9a7e55219d5a6b3b15f55e1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}git-credential-oauth -verbose 2>&1", 2)
  end
end
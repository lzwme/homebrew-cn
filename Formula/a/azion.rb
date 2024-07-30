class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.34.1.tar.gz"
  sha256 "05aeaaae348ff53846ebbf62f379353c2f240450ae3a174eaf3760f2cd0e6b8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6432e4aff28986c18a5a669eb0cf68c06febef3b05182804d7f66c9d9cb06eb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e0f888fec8440860d8fb01e96372e7bf3713ef7171336ff1442c708e0e7a619"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e44840a0e475f2996a8d50f6a9e1bfc03f4d84c1ba845cf269e41ed66141cf3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce7d4904e1d0807ec0c0adcf6439a2f493bcbfc07742630306adec14400e7439"
    sha256 cellar: :any_skip_relocation, ventura:        "1b4f664fc19f46db95e75f668e40109bf996e2fc0f10f631cbb1842174fbd159"
    sha256 cellar: :any_skip_relocation, monterey:       "1da9bb57d9b9c1c229eff6befdd319adad53774eb8ad0b601d94a7fd3f2a2730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cc2b62ddd1d254d4091a296f2bc45b4aad7df1bdc13bad7319721f018fee415"
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
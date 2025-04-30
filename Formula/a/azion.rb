class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags3.1.0.tar.gz"
  sha256 "6049eb1ac66ca7338f4883a2a5da5200248d032be89473f3ec70615cd525d655"
  license "MIT"
  head "https:github.comaziontechazion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb0a4e4d0d1dd55cd50195405dd5c291265a93ef4747a1b497eae0c522cb72ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb0a4e4d0d1dd55cd50195405dd5c291265a93ef4747a1b497eae0c522cb72ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb0a4e4d0d1dd55cd50195405dd5c291265a93ef4747a1b497eae0c522cb72ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "97e0ab169727b0b3c3c8e69d39be162325ac945b0f533bd82559df74afd6324b"
    sha256 cellar: :any_skip_relocation, ventura:       "97e0ab169727b0b3c3c8e69d39be162325ac945b0f533bd82559df74afd6324b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03af792f1be0f6aee18c8be338af08a0f7b05af16375304c35c052c5e3122c6f"
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
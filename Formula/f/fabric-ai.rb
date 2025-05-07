class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.186.tar.gz"
  sha256 "da6e2aeaf7dc83dadd2b808f92c925cd948d1cff9f9a53b9e17d9331ea888343"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da025b9cd9ac25f7f6ca1a5b6b4c1c493d0f12029bc6070de29a56fda46fd8b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da025b9cd9ac25f7f6ca1a5b6b4c1c493d0f12029bc6070de29a56fda46fd8b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da025b9cd9ac25f7f6ca1a5b6b4c1c493d0f12029bc6070de29a56fda46fd8b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "52da71eeaba4af147e02f8790b0fc3e106d82d82742eedf902c607e1fcb44663"
    sha256 cellar: :any_skip_relocation, ventura:       "52da71eeaba4af147e02f8790b0fc3e106d82d82742eedf902c607e1fcb44663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cee86730e7ce4394005d4949a198137d4868b1364eecf26bad569cc03780cd3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fabric-ai --version")

    (testpath".configfabric.env").write("t\n")
    output = shell_output("#{bin}fabric-ai --dry-run < devnull 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
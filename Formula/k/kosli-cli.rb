class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.11.4.tar.gz"
  sha256 "2365f1b7a2738d61ff7a2ffdcd8b1ec30418c27662284a230a67a4e1744a4e6a"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0938faee8f2fe9dbda0f8ac1df3f50f304e5cbf0ec58e3dcbedeab467bed4be7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3771bec567b9222249137d836665cc12480b93c0a33b63fcd0ddee0678ec334"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54f1a3307d0872863593731401687e766b00b5f95f5785cec4acdf5d4306cc7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dcdecef9127da4054386b174eebc9346a3afa493e77d5a74a95f130b2064c3d"
    sha256 cellar: :any_skip_relocation, ventura:       "2e10157f4e0d70da77acf499e3468428bdb63ca9031014ce68309cfe21a8f0b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddcd4af20502dd84f4f8bbf6f701cbb008776bada1f76ac322cd5b86ead1886b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags:), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end
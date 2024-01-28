class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https:github.comonflowcadence"
  url "https:github.comonflowcadencearchiverefstagsv0.42.8.tar.gz"
  sha256 "f636757aa07f971b51ec25c4a7f6733702ce6ef94dc1a49ff439bcaf13c25b1b"
  license "Apache-2.0"
  head "https:github.comonflowcadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71ca9a517dcde2aaf16a0f932df10813b3999806a42d6f8dad9abe745a87f106"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b7fe488c0db239d44aa03dcf9f48b9f74af51af2a3ca3d367ae3de4a22b000e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd23542b323a6dc3771dc832bf2fcd026f7c32005a9ba3b61984698efd6db32c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fe44c1028599a37bf5964c90ac2a0d2ffe3ec1671b769552d3ba5e875fc651c"
    sha256 cellar: :any_skip_relocation, ventura:        "28cb941d8805c7e71a19b4e0490db09cf1e0e586b0429103bbeb892efedfae1b"
    sha256 cellar: :any_skip_relocation, monterey:       "1e340aea705a73f3a2f24c099bb50a61ed89cb109c7520e9240295af87a8c8aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "128b501b06cf9fda9c4f8918f1b5c0c3db474feaad53a5f24446c979a1ad7a0b"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".runtimecmdmain"
  end

  test do
    (testpath"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}cadence", "hello.cdc"
  end
end
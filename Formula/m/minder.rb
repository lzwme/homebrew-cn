class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.26.tar.gz"
  sha256 "7a93827cc831cd800971e718bdd934e624c1e54b3a7280fe3dcb1be7051662db"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4ee2a4ccb8fa38fc8c1663ee4707e143ba45fbd347142e78a9b460f5057fbad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0123a8ba6f4825f9e15f519a9aca6f72edfb3177afa8b0ee7c78c91876fbf923"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9cba0ca27b87a12fb644b22b5e970877bd8f738ffb43db6680cfbbeb78d4086"
    sha256 cellar: :any_skip_relocation, sonoma:         "83ba1c9dc9bb94d9dd91a30e0635ec73d225be1f81ea06164eb075c6ea5eb054"
    sha256 cellar: :any_skip_relocation, ventura:        "0430257d83d7d1fef8675849e4e662a4e7cb181fc4b33d79c7d871ba07e22d44"
    sha256 cellar: :any_skip_relocation, monterey:       "25c836bd61ff9a95cf2c3ee77dceb7a994f96a134453d78bfec2cb19e004e381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a3bd20b84f4c0ec4c8091c81d9875e25f575415077e55ec05cc433a9aa8cb57"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
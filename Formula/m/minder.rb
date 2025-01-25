class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.82.tar.gz"
  sha256 "9632095fc9fe470a126b033b17078d7e4c150f3123846f1d563867dfdc4e4bb6"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bf59e71e10c4095be8d4f3d2be068202e5317a432b880673a1c4c767972a120"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bf59e71e10c4095be8d4f3d2be068202e5317a432b880673a1c4c767972a120"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bf59e71e10c4095be8d4f3d2be068202e5317a432b880673a1c4c767972a120"
    sha256 cellar: :any_skip_relocation, sonoma:        "db8476113b707ad8cf3cc4fae04b612d53ce72c5dedb284c762b0f2a7adb3a37"
    sha256 cellar: :any_skip_relocation, ventura:       "09f32c4eb6e1dc9a1588b7c50a3c675871b195bf1916ec56aeb52c0303ef95f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f65807b7544189657dc7e39e39678dda167dfcb34692bf80d3bc320ebdccc96"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commindersecminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
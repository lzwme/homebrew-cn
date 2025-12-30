class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.15.0",
      revision: "e1f526cbe6af4e67517e947deb7b9508a45915fe"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df691c55cd43c03be1e8ad5ac40cdbdc806468c1d519420cfca1eac926654eab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df691c55cd43c03be1e8ad5ac40cdbdc806468c1d519420cfca1eac926654eab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df691c55cd43c03be1e8ad5ac40cdbdc806468c1d519420cfca1eac926654eab"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a3bd3340a5f06ed2f98a41153372a8633a1a2fcce122d3c1bdd36574a9681c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bed9f84afde61dc4ead3de68c59549e9595ed954b8a3d0ed433766209e312da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae962cb4039fee4dedd331827fcb119968d6297c9e9e4201ba8f9046d0da555"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
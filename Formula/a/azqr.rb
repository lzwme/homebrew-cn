class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.3.3.0",
      revision: "d6df7d7798dafca175df9e01c3e677482ac789ca"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dadddfe688ca27ad57d3d141f00a3da21fc6362ebc706b0a8647710606bfd256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dadddfe688ca27ad57d3d141f00a3da21fc6362ebc706b0a8647710606bfd256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dadddfe688ca27ad57d3d141f00a3da21fc6362ebc706b0a8647710606bfd256"
    sha256 cellar: :any_skip_relocation, sonoma:        "282620caad2ad34bac90ee0a04e498e78250857bbb117b458590e2847bb1d117"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3683da7c429d67b6dd1300f09992a47ec97d7faff472b312034bf6f757c1e698"
    sha256 cellar: :any,                 x86_64_linux:  "e1a34ed95a5bddd3544130a921c595c617c124d3da37861d7984b8dd5514f294"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}]
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
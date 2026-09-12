class K0sctl < Formula
  desc "Bootstrapping and management tool for k0s clusters"
  homepage "https://github.com/k0sproject/k0sctl"
  url "https://ghfast.top/https://github.com/k0sproject/k0sctl/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "7e4e04ec24e2ba7376b8d4d03c1dd5c08955204c8b05ac6748787be23f25997d"
  license "Apache-2.0"
  head "https://github.com/k0sproject/k0sctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8614ce05c9ccddaac127ad2715a6caf20d5794707a3df155dfb0451fbd6ba5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8614ce05c9ccddaac127ad2715a6caf20d5794707a3df155dfb0451fbd6ba5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b8614ce05c9ccddaac127ad2715a6caf20d5794707a3df155dfb0451fbd6ba5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7d3d8cdb5c44fd065a251bfbbc7028d7d50f3c38cf88ffbc76a1f6f491fb1908"
    sha256 cellar: :any,                 x86_64_linux:      "35922373692c858a7079bae8059d373e0d8de2455b71771105efdd902cbab674"
  end

  depends_on "go" => :build

  def install
    inreplace "version/version.go", "Version = versioninfo.Version", "Version = \"v#{version}\"" if build.stable?

    ldflags = %W[
      -X github.com/k0sproject/k0sctl/version.Environment=production
      -X github.com/carlmjohnson/versioninfo.Revision=#{tap.user}
      -X github.com/carlmjohnson/versioninfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k0sctl", "completion", "--shell")
  end

  test do
    assert_match "version: v#{version}", shell_output("#{bin}/k0sctl version")

    output = shell_output("#{bin}/k0sctl init")
    assert_match "apiVersion: k0sctl.k0sproject.io/v1beta1", output

    output = shell_output("#{bin}/k0sctl init --cluster-name brew-test")
    assert_match "name: brew-test", output
  end
end
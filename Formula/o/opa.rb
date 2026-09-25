class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "0e486b6a7707ee60a55f239d632d6d3d5b8eca485145f8e1eb630262aac00d7d"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5cf28a8979bcc460d77e6aad90ba0b68ac8c1a8d9cbb49027003c3768b41a2e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f55cb3212e5a7027ccde74e801440bf6caedc24e46dc36b5b641b4b7b0dafeb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72c79bb58457a366a96fd859ea1c287a4511d763ac17afbf863fc451e1793ef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "64198ff91605df3f7d140d6aaff96bd257270bb2cdd38f6ee50d4823840b0232"
    sha256 cellar: :any,                 x86_64_linux:      "a81791b13ceeda8db18b79c70c1b8e9fd22ac727573b342608807d564c799e4e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/open-policy-agent/opa/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
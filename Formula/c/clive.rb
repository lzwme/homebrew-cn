class Clive < Formula
  desc "Automates terminal operations"
  homepage "https:github.comkoki-developclive"
  url "https:github.comkoki-developclivearchiverefstagsv0.12.10.tar.gz"
  sha256 "68b124c27a14c10c072fbd8acc478e4ec7ba933e1fa2e1e080725dc7814ccbec"
  license "MIT"
  head "https:github.comkoki-developclive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c60af2d39a20569870d29574d64cb0288fc8969230413bcd96deaec731000f5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c60af2d39a20569870d29574d64cb0288fc8969230413bcd96deaec731000f5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c60af2d39a20569870d29574d64cb0288fc8969230413bcd96deaec731000f5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ea5a88d1046099603f7f06babc3664f2a5c9f203064285c5c080740b2d109b8"
    sha256 cellar: :any_skip_relocation, ventura:       "3ea5a88d1046099603f7f06babc3664f2a5c9f203064285c5c080740b2d109b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "370d2026bc46831ac440ce42ea6f080601e2dc2fba8619fc8ec71ccb44d00061"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comkoki-developclivecmd.version=v#{version}")
  end

  test do
    system bin"clive", "init"
    assert_path_exists testpath"clive.yml"

    system bin"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}clive --version")
  end
end
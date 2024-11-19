class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https:docs.doppler.comdocs"
  url "https:github.comDopplerHQcliarchiverefstags3.69.2.tar.gz"
  sha256 "f775c801ba0b5891d52c50cd9836af5bedffd1440ea62842c223eff257da6628"
  license "Apache-2.0"
  head "https:github.comDopplerHQcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d9b7a59aecce073d3857df4a6ff65116741d196b2efd37980443cb6b2fde0f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d9b7a59aecce073d3857df4a6ff65116741d196b2efd37980443cb6b2fde0f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d9b7a59aecce073d3857df4a6ff65116741d196b2efd37980443cb6b2fde0f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "76234bbd3fb265283ed6eecd04c80e9790c41884867e91f9b44429e1d13cf798"
    sha256 cellar: :any_skip_relocation, ventura:       "76234bbd3fb265283ed6eecd04c80e9790c41884867e91f9b44429e1d13cf798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "747fab8af98d52fb199a0e6232e262612a968b776b7ee5baa08818bee7416594"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comDopplerHQclipkgversion.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}doppler --version")

    output = shell_output("#{bin}doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
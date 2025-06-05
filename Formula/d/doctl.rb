class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.129.0.tar.gz"
  sha256 "cdc19db73c1d41cfe32c9347a497d5da7e30e547cb15b45d437e56e3c327920d"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57842a95e9a820880c02068885b7602eb98c80cb92fad8ca989153c557bbbf58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57842a95e9a820880c02068885b7602eb98c80cb92fad8ca989153c557bbbf58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57842a95e9a820880c02068885b7602eb98c80cb92fad8ca989153c557bbbf58"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ca6d2f600ae2daa6027caddffca5d28fc720fb9c0f1d805212ec8515b24c4ed"
    sha256 cellar: :any_skip_relocation, ventura:       "4ca6d2f600ae2daa6027caddffca5d28fc720fb9c0f1d805212ec8515b24c4ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8f1a179abdf3862f2b91b08c56d6672c469bea99881f3d02158042498afec87"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdigitaloceandoctl.Major=#{version.major}
      -X github.comdigitaloceandoctl.Minor=#{version.minor}
      -X github.comdigitaloceandoctl.Patch=#{version.patch}
      -X github.comdigitaloceandoctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmddoctl"

    generate_completions_from_executable(bin"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}doctl version")
  end
end
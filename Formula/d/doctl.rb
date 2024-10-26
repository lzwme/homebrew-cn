class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.117.0.tar.gz"
  sha256 "2ff734465d45a95a1e31032ea607d05c2582ef28406d7f64142705339a58f3da"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a87297fd4b75b784c729556afb7ce4d02e4cfa388a910cc36793c8b4432ddc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a87297fd4b75b784c729556afb7ce4d02e4cfa388a910cc36793c8b4432ddc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a87297fd4b75b784c729556afb7ce4d02e4cfa388a910cc36793c8b4432ddc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d170e45553b203d0d4fe3fa1fcbe6f009108dcacfdddb2c5c0adbb4fd12224b"
    sha256 cellar: :any_skip_relocation, ventura:       "3d170e45553b203d0d4fe3fa1fcbe6f009108dcacfdddb2c5c0adbb4fd12224b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e54cfd7764e355543bcb3627bd420925257f71115dfbff306e2e928f99d3f823"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.comdigitaloceandoctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmddoctl"

    generate_completions_from_executable(bin"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}doctl version")
  end
end
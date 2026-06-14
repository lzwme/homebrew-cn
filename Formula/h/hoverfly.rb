class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://ghfast.top/https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.9.tar.gz"
  sha256 "24f24bf18f9e8fbf325ae403002f444d091e238a44ed84658f69f929562c0b02"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f31e2d5096864ca3f09deac2015a2b99b81b5adc3f2d2be83f0ee98941b33dde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f31e2d5096864ca3f09deac2015a2b99b81b5adc3f2d2be83f0ee98941b33dde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f31e2d5096864ca3f09deac2015a2b99b81b5adc3f2d2be83f0ee98941b33dde"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fcfaffde4336c1cf77c5704e0733e351b916bb3899ed3b059e842df15d2c903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "768edc5e2cc53ceda3a1a408901a8007cdf9a725bd8ff17d8d85ae31bc79dc09"
    sha256 cellar: :any,                 x86_64_linux:  "a223d1c3fc9969107a3d4d1b599093df120f01d118a3409721d3800c2f84cb43"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
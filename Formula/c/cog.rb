class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.14.6.tar.gz"
  sha256 "65a9ff0b01524cbe9b0727ef2b8841b89a61569fb20086b81fcae8094f352c03"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "423953feefa0f7c6d2fa52076b0d28a6a3f13ff6eeb2c163f78a9e47b3253dc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "423953feefa0f7c6d2fa52076b0d28a6a3f13ff6eeb2c163f78a9e47b3253dc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "423953feefa0f7c6d2fa52076b0d28a6a3f13ff6eeb2c163f78a9e47b3253dc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6cd25ae764d7fcedffe368b84a0777869ee4e5762facfe5f67b6354e99bb2bc"
    sha256 cellar: :any_skip_relocation, ventura:       "a6cd25ae764d7fcedffe368b84a0777869ee4e5762facfe5f67b6354e99bb2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13d45cdbd731b6910a982dec6ca4618898174c888459322bd3b9790bc70126f7"
  end

  depends_on "go" => :build
  depends_on "python@3.13" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def python3
    "python3.13"
  end

  def install
    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath"pkgdockerfileembed").install buildpath.glob("cog-*.whl").first

    ldflags = %W[
      -s -w
      -X github.comreplicatecogpkgglobal.Version=#{version}
      -X github.comreplicatecogpkgglobal.Commit=#{tap.user}
      -X github.comreplicatecogpkgglobal.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcog"

    generate_completions_from_executable(bin"cog", "completion")
  end

  test do
    system bin"cog", "init"
    assert_match "Configuration for Cog", (testpath"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}cog --version")
  end
end
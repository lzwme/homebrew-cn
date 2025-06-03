class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.15.2.tar.gz"
  sha256 "cbedabf253de224e02a5db99e15b3c24c40688ddbf9b7a7c92397bf5e99fabfa"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ae1cbe3a12b29a2d4f9cc193809187b684abc7ad9ddc5faad25616a8c491842"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ae1cbe3a12b29a2d4f9cc193809187b684abc7ad9ddc5faad25616a8c491842"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ae1cbe3a12b29a2d4f9cc193809187b684abc7ad9ddc5faad25616a8c491842"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b955547cab5b3fed78b280a5f18b574a9217d2ec5ddfcf3fe6a82b2a98ff479"
    sha256 cellar: :any_skip_relocation, ventura:       "2b955547cab5b3fed78b280a5f18b574a9217d2ec5ddfcf3fe6a82b2a98ff479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1be9b6e7056e490de8410a4d22a7f25638a90127d646f95af2ffdc24dc9440b"
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
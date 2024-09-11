class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.9.21.tar.gz"
  sha256 "24e5534d8040d64c81c9e46b82614412335779c0bcb272c11336775579328aac"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "14b85c0de9d3fb0c042c74e644846431f61e6ff81140b3d314001a1be341d40f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14b85c0de9d3fb0c042c74e644846431f61e6ff81140b3d314001a1be341d40f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14b85c0de9d3fb0c042c74e644846431f61e6ff81140b3d314001a1be341d40f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14b85c0de9d3fb0c042c74e644846431f61e6ff81140b3d314001a1be341d40f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d92bd29b6b6214a76bd6ad259e401aece1b78a117da2bdf74fd6bd13f5597273"
    sha256 cellar: :any_skip_relocation, ventura:        "d92bd29b6b6214a76bd6ad259e401aece1b78a117da2bdf74fd6bd13f5597273"
    sha256 cellar: :any_skip_relocation, monterey:       "d92bd29b6b6214a76bd6ad259e401aece1b78a117da2bdf74fd6bd13f5597273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a548dea6b6f36623ce7b69b81a42881cfb2a944e6a0c5bb6adda4a2e1fe2f65"
  end

  depends_on "go" => :build
  depends_on "python@3.12" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def install
    python3 = "python3.12"

    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath"pkgdockerfileembed").install buildpath.glob("cog-*.whl").first => "cog.whl"

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
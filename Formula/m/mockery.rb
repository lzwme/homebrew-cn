class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghfast.top/https://github.com/vektra/mockery/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "8aa8991f0c386e1ce4647e1e1b36c2ff20fb97c9e72bc9e3dd023a3fade40653"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "v3"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a567fa75e552812acac2e48be0fb7272e916f12b1f717edb6488c31cf93185f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62427a7b2fd38eb8005e5821401543221a8866d6ffae30c257180b479f6d0037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62427a7b2fd38eb8005e5821401543221a8866d6ffae30c257180b479f6d0037"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62427a7b2fd38eb8005e5821401543221a8866d6ffae30c257180b479f6d0037"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff592544bcfc14c49bcf374ac78dac7a7584a4c239b75e2b938f41d9c1dae44d"
    sha256 cellar: :any_skip_relocation, ventura:       "ff592544bcfc14c49bcf374ac78dac7a7584a4c239b75e2b938f41d9c1dae44d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b972f59b952fca3914c6ba716f6524e990b910c64bc4707265e47cf6bcd355da"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v#{version.major}/internal/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    (testpath/".mockery.yaml").write <<~YAML
      packages:
        github.com/vektra/mockery/v2/pkg:
          interfaces:
            TypesPackage:
    YAML
    output = shell_output("#{bin}/mockery 2>&1", 1)
    assert_match "Starting mockery", output
    assert_match "version=v#{version}", output
  end
end
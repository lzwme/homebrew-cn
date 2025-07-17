class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://ghfast.top/https://github.com/rgst-io/stencil/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "521283743d314837ba82b0ad0d738fd5c9fa5dcb19816c257fde4895be9dd77b"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77f3473bf3f8ba16c6344674b0f2da287f79aba72d3f01fe2b5c8907b9d211b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5834a628bf7d2703557e9c93eab0dd88115cdb64f8e844cc77ff31e8bc2c9529"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64f0794f37595cd7b538114c8d70ae9ae078fb1193da35419f101036e04355dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fd71cb3afe53d69fc054861e7b9cccbae8de3a75c01f24b8bd4e9be2c0765de"
    sha256 cellar: :any_skip_relocation, ventura:       "87a6bd1c34c02375548cee97889d50164da1cf64c2214a159dcd2e3f0369555b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90fa2d870e2d34d0aac40551024dc9eff01757e0453fa6b50e06e199c322760f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3212833bf4c4e52f667f56bc22c384bcfd0456fd271e973c2d72281330c1bdc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.io/stencil/v2/internal/version.version=#{version}
      -X go.rgst.io/stencil/v2/internal/version.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_path_exists testpath/"stencil.lock"
  end
end
class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://ghfast.top/https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.5.tar.gz"
  sha256 "72ae21a2b20e4d3d85e22977c5025a6c7349acc96ad596fe6b66a3d5d94b547c"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4907c40d3625ab565dde031189cb548177b1a8eff6b43d88d80039be63029b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a231a11c287124275bc9e136905bb5c0fb85b887f2e7c0ff7e6c7a4b65056221"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4151df029d1e39e184e767a5d818cef41827fb0f5b71c56bc55c61ab04c63eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3590d7612d0f4269191aa6a0b81d3b531a7e030e863e8343142e6a9d94a3263"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61fbd43b1c948aedab431c316f67cf7707f1db851d22c3b2f56e0b059664b5da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5c0eaffff32e224a023735cb0d8333bcd04a3f10e119b739f7ea6fba96e807d"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "btrfs-progs"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X kraftkit.sh/internal/version.version=#{version}
      -X kraftkit.sh/internal/version.commit=#{tap.user}
      -X kraftkit.sh/internal/version.buildTime=#{time.iso8601}
    ]
    # Upstream suggested workaround for undefined: securejoin functions
    # Issue ref: https://github.com/unikraft/kraftkit/issues/2581
    tags = %w[
      containers_image_storage_stub containers_image_openpgp netgo osusergo
    ]
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"kraft"), "./cmd/kraft"

    generate_completions_from_executable(bin/"kraft", "completion")
  end

  test do
    expected = if OS.mac?
      "could not determine hypervisor and system mode"
    else
      "finding unikraft.org/helloworld:latest"
    end
    assert_match expected, shell_output("#{bin}/kraft run unikraft.org/helloworld:latest 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/kraft version")
  end
end
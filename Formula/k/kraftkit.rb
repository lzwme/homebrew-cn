class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://ghfast.top/https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "de523f08f57ffd56635651f10f007206d197a31f273fc665b4f4f61dc3f74f12"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "720b068e2f6ddd70354bc76430bb98e7486918dcf55ee5d59f2d87592edd0802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "867972514d8e7d02946e5f2963d340c296974579ed5a1e7c67fe163f21c1ffcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "886542c26a488081bfea9253ec51a1a7d7dc53e3fe33fff8d9f297d82895bd62"
    sha256 cellar: :any_skip_relocation, sonoma:        "52db52c1c4c858ae322efeb672d723a9a2b6ede5b7a1d724d60f0b9352b0c495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "676cdec9d96e9d74b43c80ccd0e1fbe6861561c8b8bdf0c741dc80e0688a4fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31b275888916740f7b5a41bd9841f85ad08fca02015e20237354962663e3d561"
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

    generate_completions_from_executable(bin/"kraft", shell_parameter_format: :cobra)
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
class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://ghfast.top/https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "a5d60037bacc2d292ef916296c9e9c7add2aa02e18e7e32e1982abd31d2801ca"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05f34993c3e9cc4056b5e51df414cb8704a3c774e4589c53c6ca99e7260b461d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "707aedc2a6bb05218c252c202d9886ebc1ef76b1fcf6883fe7e117581232f222"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae1eb0072f0477d97975edd221436e2893eb9c568639456be9f6d81fd4a1add5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b5db0c7d67e3b7f673a4e6b5cb4fe8baeea3470271f9bf8caba5cf5d30cb9f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eeb460984e737bb53b0d218294621a9cc335adb2303b85fc1eb26ac0b4ab152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36971db99f35999f8ea1395bfa601a96e24cdff0aee32faaf49e247c5192c0d2"
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
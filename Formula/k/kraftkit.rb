class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://ghfast.top/https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "b2efe5630f2baec5900d8a1926df650d056ed761f8e7ed9df3e76d5c33f735ba"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d97f0c4b1e0a8d51677d329855e44e413879ff4815f4bcd36f420e67b278b509"
    sha256 cellar: :any,                 arm64_sequoia: "aed23744682f5ff8bacd009b67182cde3d09d2499135e04c668a10ea0b62f06d"
    sha256 cellar: :any,                 arm64_sonoma:  "92b9c51a7c7f9b732984758a2952ec436616de49f585d1d213ecfe7501317a72"
    sha256 cellar: :any,                 sonoma:        "f8aa23c80789f77c982cab25574ab1d76bfa02fbc9666920f169744deb068245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f703e08aec4d59c15742e07e645e483f9902f0c1d901178fc2b28503f99b312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "516ace3a3fd2e5f1d8901eaeafd7b0ae12b7815a36e419ccac4ab396be1fa2da"
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
    system "go", "build", *std_go_args(ldflags:, output: bin/"kraft"), "./cmd/kraft"

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
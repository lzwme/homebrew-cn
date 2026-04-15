class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://ghfast.top/https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.8.tar.gz"
  sha256 "4b6cb612a92ded1453bb0735aa326909985f9df637e1447ed69d59949fad6b84"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ded05b8d015ddbd2ccbbd667fc774024b97d5ccca91e5f3f263dd7974950c690"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a6b2bff1141c67cf431cf877b90f13b8653e0b1fbb4df34379e936d35a74f93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d0937526505fc824bf390133eafde9636f2f8f94c5e65c08b84a2b1a53e0c9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d05bf7ac4cad3313ea0c912350445e1866d865b137c75725d4f93de04d41ef34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "782225ba4127d332c686d0f89a5c3f3d56160852366b058b0d27af4bbee54481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a303b0e8645979279289753253cf3e5b97ca8cce801a3a05105cb25cf55fec"
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
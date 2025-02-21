class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https:unikraft.orgdocscli"
  url "https:github.comunikraftkraftkitarchiverefstagsv0.11.3.tar.gz"
  sha256 "c0afe55f8c161082c0d45602b33e36f59656b81b917dfb9445a7786f99345e63"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7c7eb354f1234fcadf082c2779050bc4d24d0b1169d712b07eaa206ba3f541af"
    sha256 cellar: :any,                 arm64_sonoma:  "ac4af46d2f8a7513ad539a955ae6092254c9e54e365f44d7653d7df63ec82af0"
    sha256 cellar: :any,                 arm64_ventura: "55209704d0987fc475a8dd2457d561f2728858ca947123257d596514b4257a72"
    sha256 cellar: :any,                 sonoma:        "8db7db5ce66824789917e8baae70c00c4eb78e6fc6f7f0f015ec6c68df5adaaa"
    sha256 cellar: :any,                 ventura:       "dd96543bedb10ab3cb29cc000bd787ec1a5d1d1c4462c36b87ee9c1ac2e4682f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1cd29813403920ccf64416b359600e25e2e659e17dfbaacda9f156b7d443a77"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "btrfs-progs"
  end

  def install
    ldflags = %W[
      -s -w
      -X kraftkit.shinternalversion.version=#{version}
      -X kraftkit.shinternalversion.commit=#{tap.user}
      -X kraftkit.shinternalversion.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"kraft"), ".cmdkraft"

    generate_completions_from_executable(bin"kraft", "completion")
  end

  test do
    expected = if OS.mac?
      "could not determine hypervisor and system mode"
    else
      "finding unikraft.orghelloworld:latest"
    end
    assert_match expected, shell_output("#{bin}kraft run unikraft.orghelloworld:latest 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}kraft version")
  end
end
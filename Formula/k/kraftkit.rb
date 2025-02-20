class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https:unikraft.orgdocscli"
  url "https:github.comunikraftkraftkitarchiverefstagsv0.11.2.tar.gz"
  sha256 "5ddfe0c72f843142d223b38f37a56847859bb09df19627d1083d29267eee7ece"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "56ab9274ea6dddad125fadc247501d24ffd26882e1b7afd1a4e44f9fbe12db92"
    sha256 cellar: :any,                 arm64_sonoma:  "9c62b080904a99284867185981fdb6e1a2768b5714e888cc1528bc83643e3f08"
    sha256 cellar: :any,                 arm64_ventura: "d51e4e9ccb7f17548bb8b66620b212a90a969b76828ce9f2c9b0903d10443cd1"
    sha256 cellar: :any,                 sonoma:        "c094c865212bb36ab7772d59b6eb88da6667de9586fe0569d34923ee070bd829"
    sha256 cellar: :any,                 ventura:       "36089607b35a51447b168f9db68717f592f4c54dabf6f3272e2415d2ad6c0f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "271ef06556f80f6b602106498526e50d6a73d99be646c82eb3dc28d1f34141c8"
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
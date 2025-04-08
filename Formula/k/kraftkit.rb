class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https:unikraft.orgdocscli"
  url "https:github.comunikraftkraftkitarchiverefstagsv0.11.6.tar.gz"
  sha256 "7a0cd9b656c34ec801c8bef6716787292f7ab8eada15f6919002e2db267b0801"
  license "BSD-3-Clause"
  head "https:github.comunikraftkraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "634c8de8441fb3c5cbfd4a0063321c7a3ad051f618cf97a738ffe794b7bed9e5"
    sha256 cellar: :any,                 arm64_sonoma:  "7fd1a6fc14424f9a0fca6d3f4fc64a367072b43c6c7ba91a54f5180b51f44a10"
    sha256 cellar: :any,                 arm64_ventura: "17bae80e0c3fc125743e8169c0c0d5c86fb63d66e35d8c3e45142e39e509e4c8"
    sha256 cellar: :any,                 sonoma:        "4974ca4f7496b959ae1c88c6cd68c7cb64a18ed64a1838f195243638bf924011"
    sha256 cellar: :any,                 ventura:       "4e11acfa52b9b89b9e8897b31ed7d62391b9d183344ce29b0f97ac32289acf17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6abe02b5b41416d128059d71e7a2ef503d2152bd89c71a2daeb09088fdc8e3ef"
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
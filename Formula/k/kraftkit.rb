class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https:unikraft.orgdocscli"
  url "https:github.comunikraftkraftkitarchiverefstagsv0.11.1.tar.gz"
  sha256 "8c7b00b33de1ced06d7f7cf690a7ef421c599a92b69c955ae31b7a29cad5d5a2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46dffe3bf84748907638e56f6e07cafd528ef87c4b010cae089b213f6aeaf121"
    sha256 cellar: :any,                 arm64_sonoma:  "7e9b6692f23617c5c1bc888ee19db320f7d53d63b2648fa9fcc30629b992f38a"
    sha256 cellar: :any,                 arm64_ventura: "0877a96b35fe07cf1a93b43702c8e205c36f35f2115ed4d4d284306ac5ae0658"
    sha256 cellar: :any,                 sonoma:        "235425a03f952cbcc66a4a7861aa801611962012020e028c7f7cd7187045aeeb"
    sha256 cellar: :any,                 ventura:       "dd8a8e67e3f69ccb14ad7cb2264254fd068ff825cae5c2fa37ef8491fed58970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fc768a584852f65fd9aaab1ae902f13705392dc2eccb488a845047ce5904e75"
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
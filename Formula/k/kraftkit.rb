class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https:unikraft.orgdocscli"
  url "https:github.comunikraftkraftkitarchiverefstagsv0.11.0.tar.gz"
  sha256 "a0ca6e51259fa74cb68ec4fdce6030f24aeedb131eb2d6da5011d1292ccff704"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5063dba34c2028caf346510b8c1357e433667c6956366178ca903c354998c3ae"
    sha256 cellar: :any,                 arm64_sonoma:  "bd4be5cd5c15a5c8ea68c82b8714117abb711d873ad728ab63b8e714d8700b66"
    sha256 cellar: :any,                 arm64_ventura: "cf1b1f4d7aad9715de814e30003330a84516d79f69f80531049974926585bbd3"
    sha256 cellar: :any,                 sonoma:        "a7ffb3fa267ecbfba2d6d3811bd8871b1bba85ee567aedfd35ff51737e17d340"
    sha256 cellar: :any,                 ventura:       "7999ff1ddaed31bf299655f4886093141182967488acc1814780a744b4cb3d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b15e1e15898ab9c3b81b70ed29c5e5ee20697db597cf55e16f131a50306f49ac"
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
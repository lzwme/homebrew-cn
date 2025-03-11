class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https:unikraft.orgdocscli"
  url "https:github.comunikraftkraftkitarchiverefstagsv0.11.5.tar.gz"
  sha256 "986f2661b37bbeb30036a7fbb925fea9400b9dd394779f3cfc74f396a3db31a4"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ec398783215d5c06c4bdc14f76045fee656c3a499bcc397a9547cef5b14ffa2"
    sha256 cellar: :any,                 arm64_sonoma:  "58e2f35ab2a8b80b727918d5c3e1086d67771e0eb0ab19aa654d3651c2b01bc4"
    sha256 cellar: :any,                 arm64_ventura: "1f16df741a9f76f7da33eb1815a8c333046e730fc89446646b9de692a4b0122e"
    sha256 cellar: :any,                 sonoma:        "b88033b7310dc754456882240d2fcd71a3a39f8006c7952f45dae7368cf650c7"
    sha256 cellar: :any,                 ventura:       "462aceb44f176e8f9369ec5f22a83c685eb6c52706f71a2228de789eecb46c2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e46893f38e57db810cf09658957c0d47902caffc2ec6cf27067b56df4dea14"
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
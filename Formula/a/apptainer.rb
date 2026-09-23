class Apptainer < Formula
  desc "Application container and unprivileged sandbox platform for Linux"
  homepage "https://apptainer.org/"
  url "https://ghfast.top/https://github.com/apptainer/apptainer/releases/download/v1.5.4/apptainer-1.5.4.tar.gz"
  sha256 "ec1f51e696ba384f90bc7ab2c7a438fee70da98763d001b8f3175d14a91cfcf6"
  license "BSD-3-Clause"
  head "https://github.com/apptainer/apptainer.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_linux:  "61d89963bff829735fca3394150faa81aa7ad27b0247970d372b63b82c756ee3"
    sha256 cellar: :any, x86_64_linux: "ea22bb95a9ee7b59784238531874d0f728827648a1f8f513c7063181c3795a22"
  end

  # No relocation, the localstatedir to find configs etc is compiled into the program
  pour_bottle? only_if: :default_prefix

  # TODO: unpin go@1.26 when apptainer release supports go 1.27
  # ref: https://github.com/apptainer/apptainer/pull/3563
  depends_on "go@1.26" => :build
  depends_on "pkgconf" => :build
  depends_on "libseccomp"
  depends_on :linux
  depends_on "squashfs"

  def install
    ENV["CGO_ENABLED"] = "1" if Hardware::CPU.arm?

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --without-suid
      -P release
      -v
    ]
    ENV.O0
    system "./mconfig", *args
    cd "./builddir" do
      system "make"
      system "make", "install"
    end

    generate_completions_from_executable(bin/"apptainer", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/There are [0-9]+ container file/, shell_output("#{bin}/apptainer cache list"))
    # This does not work inside older github runners, but for a simple quick check, run:
    # singularity exec library://alpine cat /etc/alpine-release
  end
end
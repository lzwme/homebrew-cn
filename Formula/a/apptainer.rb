class Apptainer < Formula
  desc "Application container and unprivileged sandbox platform for Linux"
  homepage "https:apptainer.org"
  url "https:github.comapptainerapptainerreleasesdownloadv1.3.5apptainer-1.3.5.tar.gz"
  sha256 "fe1c977da952edf1056915b2df67ae2203ef06065d4e4901a237c902329306b2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "41666d7fa1dfb3d85292f4f864a90d834bf8ff823fe6234d7b4d94f1d14a5197"
  end

  # No relocation, the localstatedir to find configs etc is compiled into the program
  pour_bottle? only_if: :default_prefix

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libseccomp"
  depends_on :linux
  depends_on "squashfs"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --without-suid
      -P release-stripped
      -v
    ]
    ENV.O0
    system ".mconfig", *args
    cd ".builddir" do
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match(There are [0-9]+ container file, shell_output("#{bin}apptainer cache list"))
    # This does not work inside older github runners, but for a simple quick check, run:
    # singularity exec library:alpine cat etcalpine-release
  end
end